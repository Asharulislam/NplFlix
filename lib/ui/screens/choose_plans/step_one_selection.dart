import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:npflix/controller/plan_controller.dart';
import 'package:npflix/controller/saveplan_controller.dart';
import 'package:npflix/models/plan_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepOneSelection extends StatefulWidget {
  const StepOneSelection({super.key});

  @override
  State<StepOneSelection> createState() => _StepOneSelectionState();
}

class _StepOneSelectionState extends State<StepOneSelection> {

  var selectedIndex = "-1";
  var currency = "";
  var planId;
  late PlanModel planModel;
  var isLoading = false;
  var toastmsg = CustomToast.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastmsg.initialize(context);
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
        body: Stack(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2)),
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
                                    selectedIndex = plan.planUuid;
                                    currency = plan.currency;

                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: selectedIndex != plan.planUuid ?  Colors.grey.shade700 : AppColors.btnColor,
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
                            if(selectedIndex != "-1"){
                              Helper.planId = planId,
                              _planSave()
                            }else{
                              toastmsg.showToast(context, message: 'Please select your plan')
                            }

                          },
                          text:  AppLocalizations.of(context)!.next
                      ),
                    ),

                  ],
                ),
              ),
            ),
            if(isLoading)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                        child: CircularProgressIndicator(

                        )
                    ),
                  ),
                ],
              )
          ],
        ),


      ),
    );
  }

  _planSave() async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
      await Provider.of<SaveplanController>(context, listen: false).savePlanId(selectedIndex,currency);
      if(Provider.of<SaveplanController>(context, listen: false).savePlan.status == Status.COMPLETED){

        setState(() {
          isLoading = false;
        });
        toastmsg.showToast(context, message: Provider.of<SaveplanController>(context, listen: false).savePlan.data.message);
        if(Provider.of<SaveplanController>(context, listen: false).savePlan.data.isFreePlan){
          SharedPreferenceManager.sharedInstance.storeString("isFreePlan", "true");

          Navigator.of(context)
              .pushNamedAndRemoveUntil(createUserName, (route) => false,);

        }else{
          Helper.successDialog(
              context, Provider.of<SaveplanController>(context, listen: false).savePlan.data.message,
              onPress: (){
            Navigator.pop(context);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginScreen, (route) => false,);
          });
        }


      } else if(Provider.of<SaveplanController>(context, listen: false).savePlan.status == Status.ERROR){
        toastmsg.showToast(context, message: Provider.of<SaveplanController>(context, listen: false).savePlan.message);
        setState(() {
          isLoading = false;
        });
      } else if(Provider.of<SaveplanController>(context, listen: false).savePlan.status == Status.NOINTERNET){
        toastmsg.showToast(context, message: Provider.of<SaveplanController>(context, listen: false).savePlan.message);
        setState(() {
          isLoading = false;
        });
      }
    }
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

