import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:npflix/utils/app_colors.dart';

import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Image.asset("assets/images/png/appIcon.png",width: 82,height: 57,),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 8),
                ),
                PlanTextBold(text: AppLocalizations.of(context)!.whos_watching,textAlign: TextAlign.start,fontSize: 20,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 8),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(bottomNavigation, (route) => false,arguments: {"index" : 0});

                  }, child: Image.asset("assets/images/png/userIcon.png",width: 195,height: 180,)),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                TextWhite(text: SharedPreferenceManager.sharedInstance.getString("userName"))

              ],
            ),
          ),
        ),

      ),
    );
  }
}
