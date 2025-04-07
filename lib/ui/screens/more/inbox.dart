import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.notifications),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: Column(
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 5),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                  itemBuilder: (context,index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          PlanText(text: "Subscription Payment",fontSize: 16,),
                          Spacer(),
                          TextGray(text: "28/06/2024",fontSize: 12,)
                        ],
                      ),
                      SizedBox(
                        height: Helper.dynamicHeight(context, 1),
                      ),
                      TextGray(text: "Thank you for subscribe. Here is your Bill. ",fontSize: 14,textAlign: TextAlign.left,),
                      SizedBox(
                        height: Helper.dynamicHeight(context, 3),
                      ),
                    ],
                  );
                })

            ],
          ),
        ),


      ),
    );
  }
}
