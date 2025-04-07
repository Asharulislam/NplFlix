import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';

import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor:  AppColors.profileScreenBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: !Helper.isTv,
                        child: Image.asset("assets/images/png/barimg.png",width: 100,height: 42,)
                    ),
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
                  child: Row(
                    children: [
                      Image.asset("assets/images/png/inbox.png", height: 24,width: 24,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.notifications),
                    ],
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(languageScreen);
                  },
                  child: Row(
                    children: [
                      Image.asset("assets/images/png/language.png", height: 24,width: 24,color: Colors.grey,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.language),
                    ],
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(roomList);
                  },
                  child: Row(
                    children: [
                      Image.asset("assets/images/png/room.png", height: 24,width: 24,color: Colors.grey,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.movie_rooms),
                    ],
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(help);
                  },
                  child: Row(
                    children: [
                      Image.asset("assets/images/png/info.png", height: 24,width: 24,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.help_faq),
                    ],
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(privacyPolicy);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined,color: Colors.white,size: 24,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.privacy_policy),
                    ],
                  ),
                ),
                SizedBox(height: Helper.dynamicHeight(context, 3),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamed(termsCondition);
                  },
                  child: Row(
                    children: [
                     // Image.asset("assets/images/png/tc.png", height: 24,width: 24,),
                      Icon(Icons.edit_note_sharp,color: Colors.white,size: 24,),
                      SizedBox(width: 10),
                      TextWhite(text: AppLocalizations.of(context)!.terms_conditions),
                    ],
                  ),
                ),

                SizedBox(
                  height: Helper.dynamicHeight(context, 10),
                ),
                Center(
                  child: ButtonWidget(
                      buttonWidth: 100,
                      onPressed: () async {
                        Helper.isFavList.clear();
                        Helper.homecontentList.clear();
                        Helper.contentList.clear();
                        Helper.langugaeId = SharedPreferenceManager.sharedInstance.getString("language_code").toString() == "en"  ? 1 : 2;
                        SharedPreferenceManager.sharedInstance
                            .clearKey(SharedPreferenceManager.sharedInstance.TOKEN);
                        await  SharedPreferenceManager.sharedInstance.clearPref();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(welcomeScreen, (route) => false);

                      },
                      text: AppLocalizations.of(context)!.log_out
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
