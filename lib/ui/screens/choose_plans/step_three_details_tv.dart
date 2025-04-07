import 'package:flutter/material.dart';
import 'package:npflix/controller/payment_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../models/plan_model.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepThreeDetailsTv extends StatefulWidget {
  Map map;
  StepThreeDetailsTv({super.key,required this.map});

  @override
  State<StepThreeDetailsTv> createState() => _StepThreeDetailsState();
}

class _StepThreeDetailsState extends State<StepThreeDetailsTv> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cardNumController = TextEditingController();
  TextEditingController cardCVVController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaymentDetails();
  }

  getPaymentDetails() async{
    await Provider.of<PaymentController>(context, listen: false).getPaymentKeys();
  }


  @override
  Widget build(BuildContext context) {
    PlanModel planModel = widget.map['plan'];
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 30),right: Helper.dynamicWidth(context, 30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                TextGray(text: AppLocalizations.of(context)!.step_03_of_03,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                 PlanTextBold(text: AppLocalizations.of(context)!.set_up_your_credit_or_debit_card, textAlign: TextAlign.start,fontSize: 20,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Row(
                  children: [
                    Image.asset("assets/images/png/visa.png",height: 36,width: 36,),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset("assets/images/png/master.png",height: 36,width: 36,),
                  ],
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                TextField(
                  style:  const TextStyle(color: Colors.white), //
                  controller: firstNameController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.first_name,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding: const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                TextField(
                  style:  TextStyle(color: Colors.white), //
                  controller: lastNameController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.last_name,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding: const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                TextField(
                  style:  TextStyle(color: Colors.white), //
                  controller: cardNumController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.card_number,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding: const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),

                TextField(
                  style: const TextStyle(color: Colors.white), //
                  controller: cardExpiryController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.expiration_date,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding:const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),

                TextField(
                  style: const TextStyle(color: Colors.white), //
                  controller: cardCVVController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.security_code,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding: const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                TextField(
                  style: const TextStyle(color: Colors.white), //
                  controller: zipCodeController,// Text color
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)!.billing_zip_code,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor, // Background color
                    contentPadding: const EdgeInsets.symmetric(
                      //vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(0)

                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),

                    ),
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.profileScreenBackground,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15,top: 12,bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWhite(text:"${planModel.finalPrice}/month",fontWeight: FontWeight.bold,),
                            TextWhite(text: planModel.title,fontWeight: FontWeight.bold,)
                          ],
                        ),
                        Spacer(),
                        InkWell(
                            onTap: (){
                              Navigator.of(context)
                                  .pushNamed(stepOneSelection);
                            },
                            child: TextRed(text:AppLocalizations.of(context)!.change,))
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: Helper.dynamicHeight(context, 5),
                ),
                Center(
                  child: ButtonWidget(
                      buttonWidth: 100,
                      onPressed: () => {
                        Navigator.of(context)
                            .pushNamed(createUserName)
                      },
                      text: AppLocalizations.of(context)!.start_membership
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




}
