import 'dart:async';
import 'package:flutter/material.dart';
import 'package:npflix/controller/otp_controller.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../controller/account_create_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../routes/index.dart';
import '../../../utils/custom_toast.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  String currentOtp = "";
  int remainingTime = 120; // 2 minutes in seconds
  Timer? _timer;
  bool isResendEnabled = false;
  var isLoading = false;
  var toastmsg = CustomToast.instance;

  @override
  void initState() {
    super.initState();
    toastmsg.initialize(context);
    startTimer();
  }

  void startTimer() {
    setState(() {
      remainingTime = 120;
      isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResendEnabled = true;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileScreenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title:  TextHeading(text: AppLocalizations.of(context)!.enter_otp),
        iconTheme: const IconThemeData(color: Colors.white),
        //automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: Helper.dynamicHeight(context, 10)),
                  TextHeading(text:AppLocalizations.of(context)!.otp_verification),
                  SizedBox(height: Helper.dynamicHeight(context, 2)),
                  TextWhite(
                    text: AppLocalizations.of(context)!.enter_the_6digit_otp_sent_to_your_email,fontSize: 16,),
                  SizedBox(height: Helper.dynamicHeight(context, 10)),
                  PinCodeTextField(
                    length: 6,
                    appContext: context,
                    controller: otpController,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeColor: AppColors.btnColor,
                      selectedColor: Colors.white,
                      inactiveColor: Colors.grey,
                      activeFillColor: Colors.red.withOpacity(0.2),
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.black,
                    ),
                    cursorColor: AppColors.btnColor,
                    textStyle: TextStyle(fontSize: 18, color: Colors.white),
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        currentOtp = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ButtonWidget(onPressed: () {
                    if (currentOtp.length == 6) {
                      // Verify OTP logic here
                      _verify();
                      print("Entered OTP: $currentOtp");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: TextWhite(text: AppLocalizations.of(context)!.please_enter_a_valid_otp)),
                      );
                    }
                  }, text: AppLocalizations.of(context)!.verify_otp),
                  SizedBox(height: 20),
                  Text(
                    isResendEnabled
                        ? AppLocalizations.of(context)!.didnt_receive_the_otp
                        : "${AppLocalizations.of(context)!.resend_otp_in} ${formatTime(remainingTime)}",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: isResendEnabled
                        ? () {
                      print("Resending OTP...");
                      resendOTP();
              
                    }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.resend_otp,
                      style: TextStyle(
                        color: isResendEnabled ? AppColors.btnColor : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isLoading)
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                      child: CircularProgressIndicator(

                      )
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  _verify() async{
    if(!isLoading){
        setState(() {
          isLoading = true;
        });
        await Provider.of<OtpController>(context, listen: false).otpVerification(otpController.text.toString());
        if(Provider.of<OtpController>(context, listen: false).otpVerify.status == Status.COMPLETED){

          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .pushNamedAndRemoveUntil(stepOneInfo, (route) => false,);
        } else if(Provider.of<OtpController>(context, listen: false).otpVerify.status == Status.ERROR){
          toastmsg.showToast(context, message: Provider.of<OtpController>(context, listen: false).otpVerify.message);
          setState(() {
            isLoading = false;
          });
        } else if(Provider.of<OtpController>(context, listen: false).otpVerify.status == Status.NOINTERNET){
          toastmsg.showToast(context, message: Provider.of<OtpController>(context, listen: false).otpVerify.message);
          setState(() {
            isLoading = false;
          });
        }
    }
  }


  resendOTP() async{
    if(!isLoading){
        setState(() {
          isLoading = true;
        });
        await Provider.of<AccountCreateController>(context, listen: false).postCreateAccount(Helper.email,Helper.password);
        if(Provider.of<AccountCreateController>(context, listen: false).account.status == Status.COMPLETED){
          setState(() {
            isLoading = false;
          });
          startTimer();

        } else if(Provider.of<AccountCreateController>(context, listen: false).account.status == Status.ERROR){
          toastmsg.showToast(context, message:  Provider.of<AccountCreateController>(context, listen: false).account.message);
          setState(() {
            isLoading = false;
          });
        }
    }
  }


}
