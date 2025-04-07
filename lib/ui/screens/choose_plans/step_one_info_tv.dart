import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class StepOneInfoTv extends StatefulWidget {
  const StepOneInfoTv({super.key});

  @override
  State<StepOneInfoTv> createState() => _StepOneInfoState();
}

class _StepOneInfoState extends State<StepOneInfoTv> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(right: Helper.dynamicWidth(context, 30),left: Helper.dynamicWidth(context, 30)),

            child: Column(
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 10),
                ),
                Center(
                  child: Image.asset("assets/images/png/checkmark.png",
                    height: 44,
                    width: 44,
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                Center(
                  child: TextGray(text: AppLocalizations.of(context)!.step_02_of_03,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                 Center(
                  child: PlanTextBold(text: AppLocalizations.of(context)!.choose_your_plan,fontSize: 20,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 5),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 5),right: Helper.dynamicHeight(context, 5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset("assets/images/png/done.png",
                          height: 22,
                          width: 22,
                        ),
                      ),

                       Expanded(
                           flex: 9,
                           child: TextWhite(text: AppLocalizations.of(context)!.no_commitments_cancel_anytime,textAlign: TextAlign.start,))
                    ],
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 5),right: Helper.dynamicHeight(context, 5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/png/done.png",
                          height: 22,
                          width: 22,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: TextWhite(
                          text: AppLocalizations.of(context)!.everything_on_NPLFLIX_for_one_low_prices,
                          textAlign: TextAlign.start,
                          maxLines: 2, // Adjust max lines as per your layout
                         // Add ellipsis if the text is still too long
                        ),
                      ),
                    ],
                  )

                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 5),right: Helper.dynamicHeight(context, 5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset("assets/images/png/done.png",
                          height: 22,
                          width: 22,
                        ),
                      ),

                       Expanded(
                         flex: 9,
                           child: TextWhite(text: AppLocalizations.of(context)!.no_ads_and_no_extra_fees_ever,textAlign: TextAlign.start,maxLines: 2,))
                    ],
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 15),
                ),
                ButtonWidget(
                    buttonWidth: 100,
                    onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(stepOneSelection)
                    },
                    text: AppLocalizations.of(context)!.next
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
