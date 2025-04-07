import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:npflix/controller/account_create_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/edit_text.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class StepTwoDetailsTv extends StatefulWidget {
  const StepTwoDetailsTv({super.key});

  @override
  State<StepTwoDetailsTv> createState() => _StepTwoDetailsState();
}

class _StepTwoDetailsState extends State<StepTwoDetailsTv> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isEmailChecked = false;
  var isLoading = false;
  var toastmsg = CustomToast.instance;
  bool _isObscuredPass = true;
  bool _isObscuredConfirmPass = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastmsg.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 30),left: Helper.dynamicWidth(context, 30)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Helper.dynamicHeight(context, 3),
                    ),
                    TextGray(text: AppLocalizations.of(context)!.step_01_of_03,),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    PlanTextBold(text: AppLocalizations.of(context)!.create_a_password_to_start_your_membership, textAlign: TextAlign.start,fontSize: 20,),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                     TextWhite(text: AppLocalizations.of(context)!.just_a_few_more_step_and_you_are_done_we_hate_paperwork_too,textAlign: TextAlign.start,),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 3),
                    ),

                    TextField(
                      style:  const TextStyle(color: Colors.white), //
                      controller: emailController,// Text color
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
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white), //
                      controller: passwordController,// Text color
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
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white), //
                      controller: confirmPasswordController,// Text color
                      obscureText: _isObscuredConfirmPass,

                      decoration:  InputDecoration(
                        hintText: AppLocalizations.of(context)!.confirm_password,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscuredConfirmPass ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.btnColor, // Icon color
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscuredConfirmPass = !_isObscuredConfirmPass; // Toggle password visibility
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
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
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
                    SizedBox(
                      height: Helper.dynamicHeight(context, 5),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Checkbox(
                            value: isEmailChecked,
                            onChanged: (bool? res) {
                              setState(() {
                                isEmailChecked = !isEmailChecked;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                         Flexible(
                            child: TextWhite(text: AppLocalizations.of(context)!.please_do_not_email_me_nplflix_special_offers,textAlign: TextAlign.left,)),
                      ],
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 5),
                    ),
                    ButtonWidget(
                        buttonWidth: 100,
                        onPressed: () => {
                         _createUser()
                        },
                        text: AppLocalizations.of(context)!.next
                    ),
                  ],
                ),
              ),
            ),
            if(isLoading)
              const Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                      child: CircularProgressIndicator(
                      )
                  ),
                ],
              )
          ],
        ),

      ),
    );
  }
  _createUser() async{

    if(!isLoading){
      if(emailController.text.isEmpty){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_email);
        debugPrint("Please enter email");
      }else if((!Helper.isEmail(emailController.text.toString()))){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_email);
        debugPrint("Please enter email");
      }else if(passwordController.text.isEmpty){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_password);
        debugPrint("Please enter Password");
      } else if(passwordController.text.length < 8){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_valid_password);
        debugPrint("Please enter Password");
      }else if(confirmPasswordController.text.isEmpty){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.enter_confirm_password);
        debugPrint("Please enter Password");
      }else if(confirmPasswordController.text.toString() != passwordController.text.toString()){
        toastmsg.showToast(context, message: AppLocalizations.of(context)!.password_and_confirm_password_should_be_same);
        debugPrint("Password are different");
      }else{
        setState(() {
          isLoading = true;
        });
        await Provider.of<AccountCreateController>(context, listen: false).postCreateAccount(emailController.text.toString(),passwordController.text.toString());
        if(Provider.of<AccountCreateController>(context, listen: false).account.status == Status.COMPLETED){
          toastmsg.showToast(context, message: "Account Created");

          SharedPreferenceManager.sharedInstance.storeString("userId", Provider.of<AccountCreateController>(context, listen: false).account.data.userID.toString());
          SharedPreferenceManager.sharedInstance.storeString("userEmail", emailController.text.toString());

          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .pushNamed(stepOneInfo);
        } else if(Provider.of<AccountCreateController>(context, listen: false).account.status == Status.ERROR){
          toastmsg.showToast(context, message:  Provider.of<AccountCreateController>(context, listen: false).account.message);
          setState(() {
            isLoading = false;
          });

        }
      }
    }

  }
}
