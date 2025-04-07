import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/language_change_controller.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LanguageChange extends StatefulWidget {
  const LanguageChange({super.key});

  @override
  State<LanguageChange> createState() => _LanguageChangeState();
}

class _LanguageChangeState extends State<LanguageChange> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.language),
          iconTheme: const IconThemeData(color: Colors.white),
          //automaticallyImplyLeading: false,
        ),
        backgroundColor:  AppColors.profileScreenBackground,
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
          child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 10),
              ),
              Center(child: TextHeading(text: AppLocalizations.of(context)!.choose_your_language)),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 15),right: Helper.dynamicWidth(context, 15)),
                child: TextWhite(text:  AppLocalizations.of(context)!.select_your_preferred_language),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 5),
              ),

              InkWell(
                onTap: (){
                  Helper.homecontentList.clear();
                  Helper.contentList.clear();
                  Provider.of<LanguageChangeController>(context, listen: false).changeLanguage(const Locale("en"));

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.imageBackground, // Light purple background
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: SharedPreferenceManager.sharedInstance.getString("language_code") == "en" ? AppColors.btnColor : Colors.white70, // Border color
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Flag Icon
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage('assets/images/png/flag_us.png'), // Replace with your flag image path
                      ),
                      const SizedBox(width: 8),
                      // Language Text
                      const Expanded(
                        child: TextWhite(text: "English / अंग्रेजी",textAlign: TextAlign.left,),
                      ),
                      // Check Icon
                      Icon(
                        SharedPreferenceManager.sharedInstance.getString("language_code") == "en" ? Icons.check_circle : Icons.circle_outlined,
                        color: SharedPreferenceManager.sharedInstance.getString("language_code") == "en" ? AppColors.btnColor : Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              InkWell(
                onTap: (){
                  Helper.homecontentList.clear();
                  Helper.contentList.clear();
                  Provider.of<LanguageChangeController>(context, listen: false).changeLanguage(const Locale("ne"));

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.imageBackground, // Light purple background
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: SharedPreferenceManager.sharedInstance.getString("language_code") == "ne" ? AppColors.btnColor : Colors.white70, // Border color
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Flag Icon
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage('assets/images/png/nepal.png'), // Replace with your flag image path
                      ),
                      const SizedBox(width: 8),
                      // Language Text
                      const Expanded(
                        child: TextWhite(text: "Nepali / नेपाली",textAlign: TextAlign.left,),
                      ),
                      // Check Icon
                      Icon(
                        SharedPreferenceManager.sharedInstance.getString("language_code") == "ne" ? Icons.check_circle : Icons.circle_outlined,
                        color: SharedPreferenceManager.sharedInstance.getString("language_code") == "ne"  ? AppColors.btnColor : Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
