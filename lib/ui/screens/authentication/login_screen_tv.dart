import 'package:flutter/material.dart';
import 'package:npflix/controller/login_controller.dart';
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

class LoginScreenTv extends StatefulWidget {
  const LoginScreenTv({super.key});

  @override
  State<LoginScreenTv> createState() => _LoginScreenTvState();
}

class _LoginScreenTvState extends State<LoginScreenTv> {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  var isLoading = false;
  var toastmsg = CustomToast.instance;
  bool _isObscuredPass = true;


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
              height: Helper.dynamicHeight(context, 100),
              width: Helper.dynamicWidth(context, 100),
              child:  Image.asset("assets/images/png/loginBackground.png",
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding:  EdgeInsets.only(top: Helper.dynamicHeight(context, 5),bottom: Helper.dynamicWidth(context, 5)),
                child: Container(
                  color: Colors.black54,
                  width:  Helper.dynamicWidth(context, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                       Padding(
                         padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 5)),
                         child: Align(
                          alignment: Alignment.bottomLeft,
                          child:  TextHeading(text: AppLocalizations.of(context)!.login),
                                           ),
                       ),
                      SizedBox(
                        height: Helper.dynamicHeight(context, 2),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 5),left: Helper.dynamicWidth(context, 5)),
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
                        padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 5),left: Helper.dynamicWidth(context, 5)),
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
                          padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 5),top: 10),
                          child: InkWell(
                              onTap: (){},
                              child:  TextGray(text: AppLocalizations.of(context)!.forgot_password)),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 5)),
                          child:  TextGray(text: AppLocalizations.of(context)!.or_continue_with),
                        ),
                      ),
                      SizedBox(
                        height: Helper.dynamicHeight(context, 2),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 5)),
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
                      SizedBox(
                        height: Helper.dynamicHeight(context, 3),
                      ),

                      Center(
                        child: Padding(
                          padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 5),left: Helper.dynamicWidth(context, 5)),
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
                      ),
                      SizedBox(
                        height: Helper.dynamicHeight(context, 2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextGray(text: "New to Nplflix?  ",fontSize: 12,),
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context)
                                    .pushNamed(stepTwoInfo);
                              },
                              child: TextGray(text: AppLocalizations.of(context)!.register,fontSize: 14,)),
                        ],
                      )


                    ],
                  ),
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
      ),
    );
  }

  _loginUser() async{
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
