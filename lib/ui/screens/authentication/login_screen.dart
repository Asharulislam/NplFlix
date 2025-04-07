import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:npflix/controller/login_controller.dart';
import 'package:npflix/models/login_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:provider/provider.dart';

import '../../../controller/list_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/custom_toast.dart';
import '../../widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  var isLoading = false;
  var toastmsg = CustomToast.instance;
  bool _isObscuredPass = true;

  RecaptchaV2Controller recaptchaController = RecaptchaV2Controller();

  String? captchaToken;
  bool isVerified = false;

  void _onVerify() {
    setState(() {
      isVerified = true;
    });
  }

  void _onError(String? error) {
    setState(() {
      isVerified = false;
      captchaToken = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("reCAPTCHA failed: $error")),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastmsg.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            SizedBox(
              height: Helper.dynamicHeight(context, 45),
              width: Helper.dynamicWidth(context, 100),
              child:  Image.asset("assets/images/png/loginBackground.png",
                fit: BoxFit.fill,
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: (){
                          Navigator.of(context)
                              .pushNamed(stepTwoInfo);
                        },
                        child:  Padding(
                          padding: const EdgeInsets.only(top: 20.0,right: 10),
                          child: TextWhite(text: AppLocalizations.of(context)!.register),
                        )
                    ),
                  ),
                  SizedBox(
                    height: Helper.dynamicHeight(context, 35),
                  ),
                   Align(
                    alignment: Alignment.bottomLeft,
                    child:  Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 3)),
                      child: TextHeading(text: AppLocalizations.of(context)!.login),
                    ),
                  ),
                  SizedBox(
                    height: Helper.dynamicHeight(context, 2),
                  ),
                  // TextFieldWithIcon(
                  //   controller: txtEmailController,
                  // ),
                  Padding(
                    padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 2),left: Helper.dynamicWidth(context, 3)),
                    child: TextField(
                      style:  const TextStyle(color: Colors.white), //
                      controller: txtEmailController,// Text color
                      decoration:  InputDecoration(
                        hintText: AppLocalizations.of(context)!.email,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundColor, // Background color
                        contentPadding: const EdgeInsets.symmetric(
                          //vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(0)

                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),

                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Helper.dynamicHeight(context, 2),
                  ),
                  // PasswordField(
                  //   txt: "Password",
                  //   controller: txtPasswordController,
                  // ),
                  Padding(
                    padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 2),left: Helper.dynamicWidth(context, 3)),
                    child: TextField(
                      style: const TextStyle(color: Colors.white), //
                      controller: txtPasswordController,// Text color
                      obscureText: _isObscuredPass,
                      decoration:  InputDecoration(
                        hintText: AppLocalizations.of(context)!.password,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscuredPass ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.btnColor, // Icon color
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscuredPass = !_isObscuredPass; // Toggle password visibility
                            });
                          },
                        ),
                        filled: true,

                        fillColor: AppColors.backgroundColor, // Background color
                        contentPadding: const EdgeInsets.symmetric(
                          //vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(0)

                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),

                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 2),top: 10),
                      child: InkWell(
                          onTap: (){},
                          child:  TextGray(text: AppLocalizations.of(context)!.forgot_password)),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 3)),
                      child:  TextGray(text: AppLocalizations.of(context)!.or_continue_with),
                    ),
                  ),
                  SizedBox(
                    height: Helper.dynamicHeight(context, 2),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 3)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){

                            },
                            child: Image.asset("assets/images/png/google.png",
                              height: 44,
                              width: 44,
                            ),
                          ),
                          SizedBox(
                            width: Helper.dynamicHeight(context, 2.2),
                          ),
                          InkWell(
                            onTap: (){

                            },
                            child: Image.asset("assets/images/png/facebook.png",
                              height: 44,
                              width: 44,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                 // SizedBox(height: 20),

                  // RecaptchaV2(
                  //   apiKey: "YOUR_RECAPTCHA_SITE_KEY",
                  //   apiSecret: "YOUR_RECAPTCHA_SECRET_KEY", // Not used for client-side validation
                  //   controller: recaptchaController,
                  //   onVerifiedSuccessfully: (token) {
                  //     setState(() {
                  //       captchaToken = token as String?;
                  //       isVerified = true;
                  //     });
                  //   },
                  //   onVerifiedError: _onError,
                  //   pluginURL: '',
                  // ),
                  SizedBox(
                    height: Helper.dynamicHeight(context, 3),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 2),left: Helper.dynamicWidth(context, 3)),
                    child: ButtonWidget(
                      buttonWidth: 100,
                        onPressed: () => {
                          // Navigator.of(context)
                          //     .pushNamed(bottomNavigation)
                          _loginUser()
                        },
                        text: AppLocalizations.of(context)!.login
                    ),
                  ),


                ],
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
      ),
    );
  }

  _loginUser() async{
    // if (!isVerified || captchaToken == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Please complete reCAPTCHA")),
    //   );
    //   return;
    // }
    if(!isLoading){
      if(txtEmailController.text.isEmpty){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_email);
        debugPrint("Please enter email");
      } else if((!Helper.isEmail(txtEmailController.text.toString()))){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_email);
        debugPrint("Please enter email");
      } else if(txtPasswordController.text.isEmpty){
        toastmsg.showToast(context, message:AppLocalizations.of(context)!.enter_valid_password);
        debugPrint("Please enter Password");
      } else if(txtPasswordController.text.length < 8){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.valid_password_length);
        debugPrint("Please enter Password");
      } else{
        setState(() {
          isLoading = true;
        });
        await Provider.of<LoginController>(context, listen: false).postLogin(txtEmailController.text.toString(),txtPasswordController.text.toString());
        if(Provider.of<LoginController>(context, listen: false).login.status == Status.COMPLETED){
          LoginModel loginModel = Provider.of<LoginController>(context, listen: false).login.data;

          if(loginModel.isProcessComplete){
            SharedPreferenceManager.sharedInstance.storeToken(loginModel.token);
            SharedPreferenceManager.sharedInstance.storeString("userId", Provider.of<LoginController>(context, listen: false).login.data.userID.toString());
            SharedPreferenceManager.sharedInstance.storeString("userEmail", Provider.of<LoginController>(context, listen: false).login.data.email.toString() );
            SharedPreferenceManager.sharedInstance.storeString("profileId", Provider.of<LoginController>(context, listen: false).login.data.profileId.toString() );
            SharedPreferenceManager.sharedInstance.storeString("userName", Provider.of<LoginController>(context, listen: false).login.data.profileName.toString() );
            SharedPreferenceManager.sharedInstance.storeString("isFreePlan", Provider.of<LoginController>(context, listen: false).login.data.isFreePlan.toString());
            await Provider.of<ListController>(context, listen: false).getList();
            setState(() {
              isLoading = false;
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil(bottomNavigation, (route) => false,arguments: {"index" : 0});
          }else if(loginModel.isEmailConfirmed ==  false){
            SharedPreferenceManager.sharedInstance.storeToken(loginModel.token);
            SharedPreferenceManager.sharedInstance.storeString("userId", Provider.of<LoginController>(context, listen: false).login.data.userID.toString());
            SharedPreferenceManager.sharedInstance.storeString("userEmail", Provider.of<LoginController>(context, listen: false).login.data.email.toString() );
            setState(() {
              isLoading = false;
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil(otpScreen, (route) => false);
          }else if(!loginModel.isPaymentDone){
            SharedPreferenceManager.sharedInstance.storeToken(loginModel.token);
            SharedPreferenceManager.sharedInstance.storeString("userId", Provider.of<LoginController>(context, listen: false).login.data.userID.toString());
            SharedPreferenceManager.sharedInstance.storeString("userEmail", Provider.of<LoginController>(context, listen: false).login.data.email.toString() );
            setState(() {
              isLoading = false;
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil(stepOneInfo, (route) => false);
          }else if(loginModel.profileId == null){
            SharedPreferenceManager.sharedInstance.storeToken(loginModel.token);
            SharedPreferenceManager.sharedInstance.storeString("userId", Provider.of<LoginController>(context, listen: false).login.data.userID.toString());
            SharedPreferenceManager.sharedInstance.storeString("userEmail", Provider.of<LoginController>(context, listen: false).login.data.email.toString() );
            setState(() {
              isLoading = false;
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil(createUserName, (route) => false);

          }


        } else if(Provider.of<LoginController>(context, listen: false).login.status == Status.ERROR){
          toastmsg.showToast(context, message: Provider.of<LoginController>(context, listen: false).login.message);
          setState(() {
            isLoading = false;
          });
        } else if(Provider.of<LoginController>(context, listen: false).login.status == Status.NOINTERNET){
          toastmsg.showToast(context, message: Provider.of<LoginController>(context, listen: false).login.message);
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

}
