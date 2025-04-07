import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.app_settings),
          iconTheme: IconThemeData(color: AppColors.btnColor),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: Column(
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 3),
              ),
              InkWell(
                onTap: (){

                },
                child: Row(
                  children: [
                    TextWhite(text: "Notifications & Messages",fontSize: 14,),
                    Spacer(),
                    Icon(Icons.navigate_next_rounded,color: Colors.white,)
                  ],
                ),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 4),
              ),
              // InkWell(
              //   onTap: (){
              //
              //   },
              //   child: Row(
              //     children: [
              //       TextWhite(text: "Two-Factor Authentication",fontSize: 14,),
              //       Spacer(),
              //       Icon(Icons.navigate_next_rounded,color: Colors.white,)
              //     ],
              //   ),
              // ),

              InkWell(
                onTap: (){

                },
                child: Row(
                  children: [
                    TextWhite(text: AppLocalizations.of(context)!.app_settings,fontSize: 14,),
                    Spacer(),
                    Icon(Icons.navigate_next_rounded,color: Colors.white,)
                  ],
                ),
              ),

            ],
          ),
        ),


      ),
    );
  }
}
