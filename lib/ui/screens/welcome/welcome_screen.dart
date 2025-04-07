import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:npflix/controller/language_change_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/button.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../sources/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLanguage();
  }

  setLanguage(){
    if(SharedPreferenceManager.sharedInstance.getString("language_code") == null){
      LanguageChangeController().changeLanguage(Helper.langugaeId == 1 ? const Locale("en"): const Locale("ne"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
                child: Row(
                  children: [
                    Image.asset("assets/images/png/barimg.png",width: 100,height: 42,),
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        if(Provider.of<LanguageChangeController>(context, listen: false).appLocale.languageCode == "en"){
                          Provider.of<LanguageChangeController>(context, listen: false).changeLanguage(const Locale("ne"));
                        }else{
                          Provider.of<LanguageChangeController>(context, listen: false).changeLanguage(const Locale("en"));
                        }
                      },
                      child: Image.asset("assets/images/png/language.png",
                        height: 40,
                        width: 40,
                        color: AppColors.btnColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 3),
              ),
              Center(
                child: Image.asset("assets/images/png/welcomeIcon.png",
                  height: 220,
                  width: 240,
                ),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              TextHeading(text: AppLocalizations.of(context)!.welcome_to_NPLFLIX,fontWeight: FontWeight.bold,),
              TextGray(text: AppLocalizations.of(context)!.movie_streaming_all_your_needs),
              SizedBox(
                height: Helper.dynamicHeight(context, 10),
              ),

              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),

                    child: ButtonWidget(
                        buttonWidth: Helper.isTv ? 40 : 100,
                        onPressed: () => {
                        Navigator.of(context)
                            .pushNamed(loginScreen)
                        },
                        text: AppLocalizations.of(context)!.watch_movie
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              InkWell(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(stepTwoInfo);
                  },
                  child:  TextWhite(text: AppLocalizations.of(context)!.sign_up)
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
