import 'package:flutter/material.dart';
import 'package:npflix/models/plan_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/utils/app_colors.dart';

import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepThreeInfoTv extends StatefulWidget {
  Map map;
  StepThreeInfoTv({super.key,required this.map});

  @override
  State<StepThreeInfoTv> createState() => _StepThreeInfoState();
}

class _StepThreeInfoState extends State<StepThreeInfoTv> {

  @override
  Widget build(BuildContext context) {
    PlanModel planModel = widget.map['plan'];
    return  SafeArea(
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
                  child: TextGray(text: AppLocalizations.of(context)!.step_03_of_03,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                 Center(
                  child: PlanTextBold(text: AppLocalizations.of(context)!.choose_how_to_pay,fontSize: 20,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Center(
                  child: PlanText(text: AppLocalizations.of(context)!.your_payment_in_encrypted_and_you_can_change_how_you_pay_any_time,textAlign: TextAlign.center,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Center(
                  child: TextWhite(text: AppLocalizations.of(context)!.secure_of_peace_of_mind_cancel_easily_online,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 5),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2)),
                  child: Row(
                    children: [
                      Spacer(),
                      PlanText(text: AppLocalizations.of(context)!.end_to_end_encrypted),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset("assets/images/png/lock.png",height: 15,width: 15,),

                    ],
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    border:
                    Border.all(color: Colors.grey.shade700, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:12.0,bottom: 12,left: 8,right: 8),
                    child: Row(
                      children: [
                        TextWhite(text: AppLocalizations.of(context)!.credit_or_debit_card,),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset("assets/images/png/visa.png",height: 22,width: 22,),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset("assets/images/png/master.png",height: 22,width: 22,),


                        const Spacer(),
                        Icon(Icons.navigate_next_rounded,color: Colors.grey.shade700,)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 10),
                ),

                ButtonWidget(
                    buttonWidth: 100,
                    onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(stepThreeDetails,arguments: {
                            "plan" : planModel
                          })
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
