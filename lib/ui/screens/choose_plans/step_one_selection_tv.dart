import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:npflix/controller/plan_controller.dart';
import 'package:npflix/models/plan_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepOneSelectionTv extends StatefulWidget {
  const StepOneSelectionTv({super.key});

  @override
  State<StepOneSelectionTv> createState() => _StepOneSelectionState();
}

class _StepOneSelectionState extends State<StepOneSelectionTv> {

  var selectedIndex = -1;
  var planId;
  late PlanModel planModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlan();
  }

  getPlan() async {
    await Provider.of<PlanController>(context, listen: false).fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child:  Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 30),right: Helper.dynamicWidth(context, 30)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                TextGray(text:  AppLocalizations.of(context)!.step_02_of_03,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                PlanTextBold(text:  AppLocalizations.of(context)!.choose_the_plan_that_right_for_you, textAlign: TextAlign.start,fontSize: 20,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                Consumer<PlanController>(
                  builder: (context, controller, child) {
                    if (controller.planList.status == Status.LOADING) {
                      return SizedBox(
                          height: Helper.dynamicHeight(context, 60),
                          child: const Center( child: CircularProgressIndicator())
                      );
                    }else if (controller.planList.status == Status.NOINTERNET) {
                      return NoInternetScreen(
                        onPressed: (){
                          getPlan();
                        },
                      );
                    } else if (controller.planList.status == Status.ERROR) {
                      return ErrorScreen(
                        errorMessage: controller.planList.message,
                        onRetry: (){
                          getPlan();
                        },
                      );
                    } else if (controller.planList.status == Status.COMPLETED) {
                      return CarouselSlider.builder(
                        itemCount: controller.planList.data.length ?? 0,
                        itemBuilder: (context, index, realIndex) {
                          final plan =  controller.planList.data[index];
                          return InkWell(
                            onTap: (){
                              setState(() {
                                planId = plan.planId;
                                planModel = plan;
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: selectedIndex != index ?  Colors.grey.shade700 : AppColors.btnColor,
                                      width: 1.5
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:  Helper.dynamicWidth(context, 100),
                                          decoration:  BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF1D2671), // Dark blue
                                                  Color(0xFF4158D0), // Light blue
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child:  Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                PlanTextBold(text: plan.title),
                                                PlanText(text: plan.resolution)
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(color: Colors.grey),
                                        const SizedBox(height: 5),
                                        const PlanText(text: "Monthly price",),
                                        const SizedBox(height: 5),
                                        PlanTextBold(text:  plan.finalPrice.toString(),fontSize: 14,),
                                        buildPlanDetail(
                                            'Video and sound quality',plan.videoAndSoundQuality.toString()),
                                        buildPlanDetail('Resolution', plan.resolution.toString()),
                                        buildPlanDetail(
                                            'Supported devices', plan.supportedDevice.toString()),
                                        buildPlanDetail(
                                            'Devices your household can watch at the same time',
                                            plan.noOfProfilesAllowed.toString()),
                                        buildPlanDetail('Download devices',
                                            plan.noOfDownloadsAllowed.toString()),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: Helper.dynamicHeight(context, 60),
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          //viewportFraction: 0.9,
                          onPageChanged: (index, reason) {

                          },
                        ),
                      );
                    }
                    return Container();
                  },
                )
                ,
            
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                Center(
                  child: ButtonWidget(
                      buttonWidth: 100,
                      onPressed: () => {
                        if(selectedIndex != -1){
                          Helper.planId = planId,
                          Navigator.of(context)
                              .pushNamed(stepThreeInfo ,arguments: {
                            "plan" : planModel
                          })

                        }else{

                        }

                      },
                      text:  AppLocalizations.of(context)!.next
                  ),
                ),
            
              ],
            ),
          ),
        ),


      ),
    );
  }
  /// Helper to build each detail row
  Widget buildPlanDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.grey),
        const SizedBox(height: 5),
        PlanText(text: title,textAlign: TextAlign.start,),
        const SizedBox(height: 5),
        PlanText(text: value),
      ],
    );
  }
}

