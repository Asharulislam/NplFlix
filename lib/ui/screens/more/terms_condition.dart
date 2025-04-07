import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.terms_conditions),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 5),
              ),

              PlanTextBold(text: AppLocalizations.of(context)!.nplflix_terms_of_services,textAlign: TextAlign.start,fontSize: 16,),
              SizedBox(
                height: Helper.dynamicHeight(context, 3 ),
              ),
              const PlanText(text: "Terms of service are a set of guidelines and rules that must be honored by an organization or an individual if they want to use a certain service. In general, terms of service agreement is legally binding, but if it violates some law on a local, or federal level it's not. Terms of service are subjected to change and if they do change, the person or the company providing a service needs to notify all the users in a timely manner. Websites and mobile apps that only provide their visitors with information or sell products usually don't require terms of service, but if we are talking about providers that offer services online or on a site that will keep the user's personal data, then the terms of service agreement is required. Some of the broadest examples where the terms of service agreement is mandatory include social media, financial transaction websites and online auctions.",textAlign: TextAlign.justify,),
            ],
          ),
        ),


      ),
    );
  }
}
