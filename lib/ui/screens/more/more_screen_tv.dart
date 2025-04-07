import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';

import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreScreenTv extends StatefulWidget {
  const MoreScreenTv({super.key});

  @override
  State<MoreScreenTv> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreenTv> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor:  AppColors.profileScreenBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2),top:  Helper.dynamicHeight(context, 2)),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Spacer(),
                    TextHeading(text: AppLocalizations.of(context)!.more),
                  ],
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                Image.asset("assets/images/png/userIcon.png",width: 70,height: 70,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                PlanTextBold(text: SharedPreferenceManager.sharedInstance.getString("userName") ?? "XYZ",fontSize: 21,),
                TextGray(text: SharedPreferenceManager.sharedInstance.getString("userEmail") ?? ""),
                SizedBox(height: Helper.dynamicHeight(context, 1),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(editProfile);
                  },
                    child: TextRed(text: AppLocalizations.of(context)!.edit_profile)
                ),
                SizedBox(height: Helper.dynamicHeight(context, 2),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(inbox);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 29),right: Helper.dynamicWidth(context, 29),top:  Helper.dynamicHeight(context, 2)),

                    child: Row(
                      children: [
                        Image.asset("assets/images/png/inbox.png", height: 24,width: 24,),
                        SizedBox(width: 10),
                        TextWhite(text: AppLocalizations.of(context)!.notifications),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(languageScreen);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 29),right: Helper.dynamicWidth(context, 29),top:  Helper.dynamicHeight(context, 2)),
                    child: Row(
                      children: [
                        Image.asset("assets/images/png/language.png", height: 24,width: 24,color: Colors.grey,),
                        SizedBox(width: 10),
                        TextWhite(text: AppLocalizations.of(context)!.language),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(help);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 29),right: Helper.dynamicWidth(context, 29),top:  Helper.dynamicHeight(context, 2)),

                    child: Row(
                      children: [
                        Image.asset("assets/images/png/info.png", height: 24,width: 24,),
                        SizedBox(width: 10),
                        TextWhite(text: AppLocalizations.of(context)!.help_faq),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 4),
                ),
                InkWell(
                    onTap: (){
                      Navigator.of(context)
                          .pushNamed(termsCondition);
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 29),right: Helper.dynamicWidth(context, 29),top:  Helper.dynamicHeight(context, 2)),

                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextGray(text: AppLocalizations.of(context)!.terms_conditions)),
                    )
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Center(
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 29),right: Helper.dynamicWidth(context, 29),top:  Helper.dynamicHeight(context, 2)),
                    child: ButtonWidget(
                        buttonWidth: 100,
                        onPressed: () async {
                          Helper.isFavList.clear();
                          SharedPreferenceManager.sharedInstance
                              .clearKey(SharedPreferenceManager.sharedInstance.TOKEN);
                          await  SharedPreferenceManager.sharedInstance.clearPref();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(welcomeScreen, (route) => false);

                        },
                        text: AppLocalizations.of(context)!.log_out
                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
