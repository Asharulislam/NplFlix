import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  var selectedIndex = -1;
  List<String> questions = ["How to delete continue watching?","How to delete my list"];
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.help),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 5),
              ),
               PlanTextBold(text: AppLocalizations.of(context)!.frequently_ask_question,textAlign: TextAlign.start,fontSize: 16,),
              SizedBox(
                height: Helper.dynamicHeight(context, 3),
              ),
              Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: questions.length,
                      itemBuilder: (context,index){
                    return Column(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              if(selectedIndex != index){
                                selectedIndex = index;
                              }else{
                                selectedIndex = -1;
                              }

                            });
                          },
                          child: Container(
                            color: AppColors.appBarColor,
                            width: Helper.dynamicWidth(context, 100),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 12,bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Padding(
                                    padding: EdgeInsets.only(left:5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 8,
                                            child: TextWhite(text: questions[index],textAlign: TextAlign.left,)
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Icon(Icons.keyboard_arrow_down_rounded,color: AppColors.btnColor,))
                                        ),

                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedIndex == index,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: TextWhite(text: "Go to More -> choose App setting -> click Delete",textAlign: TextAlign.left,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Helper.dynamicHeight(context, 2),
                        ),
                      ],
                    );
                  })
              )

            ],
          ),
        ),


      ),
    );
  }
}
