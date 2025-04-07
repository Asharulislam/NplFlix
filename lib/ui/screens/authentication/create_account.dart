import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';

import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/edit_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: AppColors.btnColor
          ),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 3),
              ),
              TextHeading(text: "Create Account"),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
               TextGray(text: AppLocalizations.of(context)!.or_login_with_social,textAlign: TextAlign.start,),
              TextFieldWithIcon(
                controller: txtEmailController,
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              PasswordField(
                controller: txtPasswordController,
                txt: AppLocalizations.of(context)!.password,
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              PasswordField(
                controller: txtPasswordController,
                txt: AppLocalizations.of(context)!.confirm_password,
              ),

              SizedBox(
                height: Helper.dynamicHeight(context, 4),
              ),
              Align(
                alignment: Alignment.topLeft,
                child:  TextGray(text:AppLocalizations.of(context)!.or_continue_with),
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

              const Spacer(),
              ButtonWidget(
                  onPressed: () => {
                    Navigator.of(context)
                        .pushNamed(stepOneInfo)
                  },
                  text: AppLocalizations.of(context)!.register
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 3),
              ),


            ],
          ),
        ),

      ),
    );
  }
}
