import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class StepTwoInfo extends StatefulWidget {
  const StepTwoInfo({super.key});

  @override
  State<StepTwoInfo> createState() => _StepTwoInfoState();
}

class _StepTwoInfoState extends State<StepTwoInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 2),left: Helper.dynamicWidth(context, 3)),

            child: Column(
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 10),
                ),
                Center(
                  child: Image.asset("assets/images/png/steptwo.png",
                    height: 87,
                    width: 216,
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                Center(
                  child: TextGray(text: AppLocalizations.of(context)!.step_01_of_03,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                Center(
                  child: PlanTextBold(text: AppLocalizations.of(context)!.finish_setting_up_your_account,fontSize: 20,textAlign: TextAlign.center,),
                ),

                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                 TextWhite(text: AppLocalizations.of(context)!.nplflix_is_personalized_of_you_create_a_password_to_watch_on_any_devices_at_any_time),

                SizedBox(
                  height: Helper.dynamicHeight(context, 15),
                ),
                ButtonWidget(
                    buttonWidth: 100,
                    onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(stepTwoDetails)
                    },
                    text:AppLocalizations.of(context)!.next
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
