import 'package:flutter/material.dart';
import 'package:npflix/ui/screens/bottomnavigation/tv_side_bar.dart';
import 'package:provider/provider.dart';

import '../../../controller/content_controller.dart';
import '../../../controller/list_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../models/content_model.dart';
import '../../../network_module/api_base.dart';
import '../../../routes/index.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/error_screen.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreenTv extends StatefulWidget {
  const HomeScreenTv({super.key});

  @override
  State<HomeScreenTv> createState() => _HomeScreenTvState();
}

class _HomeScreenTvState extends State<HomeScreenTv> {
  List<String> tabList = [];
  var selectedIndex = 0;
  var toastmsg = CustomToast.instance;
  bool isListCheck = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContent();
    toastmsg.initialize(context);

  }


  getContent() async {
    await Provider.of<ContentController>(context, listen: false).fetchContentList();
  }



  @override
  Widget build(BuildContext context) {
    tabList = [AppLocalizations.of(context)!.featured,AppLocalizations.of(context)!.movies,AppLocalizations.of(context)!.music];

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    // Number of grid columns
    const crossAxisCount = 2;
    // Dynamically calculate grid item width
    const crossAxisSpacing = 10.0; // Static spacing between columns
    final gridItemWidth = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount;
    // Desired grid item height
    const gridItemHeight = 250.0;

    // Dynamically calculate childAspectRatio
    final childAspectRatio = gridItemWidth / gridItemHeight;
    final isTV = MediaQuery.of(context).size.width > 1080;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Consumer<ContentController>(
              builder: (context, controller, child) {
                if (controller.contentList.status == Status.LOADING) {
                  return SizedBox(
                    height: Helper.dynamicHeight(context, 70),
                    child: const Center(
                        child: CircularProgressIndicator(
                        )
                    ),
                  );
                }
                else if(controller.contentList.status ==  Status.NOINTERNET){
                  return Expanded(
                    child: Center(
                      child: NoInternetScreen(
                        onPressed: (){
                          getContent();
                        },
                      ),
                    ),
                  );
                }
                else if (controller.contentList.status == Status.ERROR) {
                  return Expanded(
                    child: Center(
                      child: ErrorScreen(
                        errorMessage: controller.contentList.message,
                        onRetry: (){
                          getContent();
                        },
                      ),
                    ),
                  );
                }
                else if (controller.contentList.status == Status.COMPLETED) {
                  return  Expanded(
                    child: Container(
                      color: AppColors.profileScreenBackground,
                      width: Helper.dynamicWidth(context, 100),
                      child: SingleChildScrollView(
                          child:  Consumer<ContentController>(
                            builder: (context, controller, child) {
                              if (controller.contentList.status == Status.LOADING) {
                                return SizedBox(
                                  height: Helper.dynamicHeight(context, 100),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                      )
                                  ),
                                );
                              }
                              else if (controller.contentList.status == Status.ERROR) {
                                return Center(child: TextWhite(text: 'Error: ${controller.contentList.message}'));
                              }
                              else if (controller.contentList.status == Status.COMPLETED) {
                                return   Stack(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context)
                                                .pushNamed(movieDetails,arguments: {
                                              "content" : controller.contentList.data[14]
                                            });
                                          },
                                          child: Card(
                                            elevation: 2,
                                            color: Colors.transparent,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(0),
                                              child: Image.network(
                                                "${APIBase.baseImageUrl+controller.contentList.data[14].uuid}/img-banner-xl-h.jpg",
                                               // height: Helper.dynamicHeight(context, 70),
                                                width: Helper.dynamicWidth(context, 100),
                                                fit: BoxFit.fill,
                                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child; // The image has finished loading.
                                                  }
                                                  return Container(
                                                      height: Helper.dynamicHeight(context, 70),
                                                      width: Helper.dynamicWidth(context, 100),
                                                      color:  AppColors.imageBackground,// Placeholder background color.
                                                      child: Center(
                                                        child: TextWhite(text:  controller.contentList.data[14].title),
                                                      )
                                                  );
                                                },
                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                  return Container(
                                                      height: Helper.dynamicHeight(context, 40),
                                                      width: Helper.dynamicWidth(context, 100),
                                                      color: AppColors.imageBackground, // Background color for error state.
                                                      child: Center(
                                                        child: TextWhite(text: controller.contentList.data[14].title),
                                                      )
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          height: MediaQuery.of(context).size.height * 1, // 10% of screen height
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.7), // Start color
                                                  Colors.transparent, // End color
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Container(
                                        //   height: Helper.dynamicHeight(context, 100),
                                        //   width: Helper.dynamicWidth(context, 100),
                                        //   decoration: BoxDecoration(
                                        //     gradient: LinearGradient(
                                        //       begin: Alignment.bottomLeft, // Start from the left
                                        //       end: Alignment.bottomRight, // End at the right
                                        //       colors: [
                                        //         Colors.black.withOpacity(0.9), // Start color
                                        //         Colors.black.withOpacity(0.2), // End color
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: Helper.dynamicWidth(context, 45),
                                          child: Padding(
                                            padding:  EdgeInsets.only(top: Helper.dynamicHeight(context, 2),left: Helper.dynamicWidth(context, 2)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height:  Helper.dynamicHeight(context, 3),
                                                ),
                                                Image.network(
                                                  "${APIBase.baseImageUrl+controller.contentList.data[14].uuid}/img-title-lg-h.png",
                                                  height: Helper.dynamicHeight(context, 30),
                                                  fit: BoxFit.fill,
                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      return child; // The image has finished loading.
                                                    }
                                                    return Container(
                                                        height: Helper.dynamicHeight(context, 15),
                                                        width: Helper.dynamicWidth(context, 80),
                                                        color:  AppColors.imageBackground,// Placeholder background color.
                                                        child: Center(
                                                          child: TextWhite(text:  controller.contentList.data[14].title),
                                                        )
                                                    );
                                                  },
                                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                    return Container(
                                                        height: Helper.dynamicHeight(context, 15),
                                                        width: Helper.dynamicWidth(context, 80),
                                                        color: AppColors.imageBackground, // Background color for error state.
                                                        child: Center(
                                                          child: TextWhite(text: controller.contentList.data[14].title),
                                                        )
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  height:  Helper.dynamicHeight(context, 3),
                                                ),
                                                TextWhite(text: controller.contentList.data[14].synopsis,textAlign: TextAlign.start,),
                                                SizedBox(
                                                  height:  Helper.dynamicHeight(context, 3),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 0)),
                                                        child: ButtonTextIconWidget(
                                                            onPressed: (){
                                                              Navigator.of(context)
                                                                  .pushNamed(nplflixVideoPlayer,arguments: {
                                                                "url" : "controller.contentList.data[14].video",
                                                                "name" : controller.contentList.data[14].title,
                                                              });
                                                            },
                                                            icon:  Icons.play_arrow,
                                                            text: AppLocalizations.of(context)!.play),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Helper.dynamicWidth(context, 2),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:EdgeInsets.only(right: Helper.dynamicWidth(context, 0)),
                                                        child: StreamBuilder<bool>(
                                                            stream: context.read<ListController>().isInListController.stream,
                                                            initialData: false,
                                                            builder: (context, snapshot) {
                                                              if(isListCheck){
                                                                context.read<ListController>().checkList(controller.contentList.data[14].contentId);
                                                                isListCheck = false;
                                                              }
                                                              return ButtonTextIconWidget(
                                                                onPressed: () async {

                                                                  Navigator.of(context)
                                                                      .pushNamed(movieDetails,arguments: {
                                                                    "content" : controller.contentList.data[14]
                                                                  });
                                                                },
                                                                icon: Icons.info,
                                                                text: AppLocalizations.of(context)!.details,
                                                                color: AppColors.containerBackground,
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),

                                    Padding(
                                      padding:  EdgeInsets.only(top: Helper.dynamicHeight(context, 60),),
                                      child: ListView.builder(
                                        //itemCount: controller.homecontent.data.where((item) => item.type.contains("Featured")).length,
                                          itemCount: controller.homecontent.data
                                              .where((home) => home.type == "Featured") // Filter HomeContent by type
                                              .expand((home) => home.headingModel) // Flatten headingModel lists
                                              .toList()
                                              .length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            final filteredList = controller.homecontent.data
                                                .where((home) => home.type == "Featured") // Filter HomeContent by type
                                                .expand((home) => home.headingModel) // Flatten headingModel lists
                                                .toList();
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: Helper.dynamicHeight(context, 4),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                                                  child:  PlanTextBold(text: filteredList[index].heading),
                                                ),
                                                SizedBox(
                                                  height: Helper.dynamicHeight(context, 1),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2),),
                                                  child: SizedBox(
                                                    height:  Helper.dynamicHeight(context, 25),
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        // itemCount: controller.contentList.data.length,
                                                        itemCount : filteredList[index].headingContentModel.length,
                                                        itemBuilder: (context,position){
                                                          // Content contentData = controller.contentList.data.where((item) => item.type.contains(filteredList[index].headingContentModel[position].uuid)) as Content;
                                                          // Find the matching Content object where uuid exists
                                                          final Content contentData = controller.contentList.data.firstWhere(
                                                                (item) => item.uuid != null &&
                                                                item.uuid!.contains(filteredList[index].headingContentModel[position].uuid),
                                                            orElse: () => Content(), // Provide a fallback if no match is found
                                                          );
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context).pushNamed(movieDetails,
                                                                  arguments: {
                                                                    "content": contentData
                                                                  });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.only(right: Helper.dynamicHeight(context, 0)),
                                                              child: Card(
                                                                elevation: 2,
                                                                color: Colors.transparent,
                                                                child: filteredList[index].headingId.toString() != "11" ?
                                                                SizedBox(
                                                                    width: Helper.dynamicWidth(context, 25),
                                                                    height: Helper.dynamicHeight(context, 25),
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      child: Image.network("${APIBase.baseImageUrl+contentData.uuid}/img-thumb-md-h.jpg",
                                                                        fit: BoxFit.fill,
                                                                        loadingBuilder: (
                                                                            BuildContext context,
                                                                            Widget child,
                                                                            ImageChunkEvent? loadingProgress) {
                                                                        if (loadingProgress == null) {
                                                                            return child; // The image has finished loading.
                                                                          }
                                                                          return Container(
                                                                              color:  AppColors.imageBackground,
                                                                              // Placeholder background color.
                                                                              child: Center(
                                                                                child: TextWhite(text: contentData.title),
                                                                              )
                                                                          );
                                                                        },
                                                                        errorBuilder: (
                                                                            BuildContext context,
                                                                            Object error,
                                                                            StackTrace? stackTrace) {
                                                                          return Container(
                                                                              color: AppColors.imageBackground,
                                                                              // Background color for error state.
                                                                              child: Center(
                                                                                child: TextWhite(text: contentData.title),
                                                                              )
                                                                          );
                                                                        },
                                                                      ),
                                                                    )
                                                                ) :
                                                                SizedBox(
                                                                  width: Helper.dynamicWidth(context, 25),
                                                                  height: Helper.dynamicHeight(context, 25),
                                                                  // Adjust as needed
                                                                  child: Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        child: Image.network(
                                                                          "${APIBase.baseImageUrl+contentData.uuid}/img-thumb-md-h.jpg",
                                                                          width: Helper.dynamicWidth(context, 43),
                                                                          height: Helper.dynamicHeight(context, 25),
                                                                          // Same height
                                                                          fit: BoxFit.fill,
                                                                          // Use BoxFit.cover for full coverage
                                                                          loadingBuilder: (
                                                                              BuildContext context,
                                                                              Widget child,
                                                                              ImageChunkEvent? loadingProgress) {
                                                                            if (loadingProgress ==
                                                                                null) {
                                                                              return child; // The image has finished loading.
                                                                            }
                                                                            return Container(
                                                                                color: AppColors.imageBackground,
                                                                                // Placeholder background color.
                                                                                child: Center(
                                                                                  child: TextWhite(text: contentData.title),
                                                                                )
                                                                            );
                                                                          },
                                                                          errorBuilder: (
                                                                              BuildContext context,
                                                                              Object error,
                                                                              StackTrace? stackTrace) {
                                                                            return Container(
                                                                                width:  Helper.dynamicWidth(context, 43),
                                                                                color:  AppColors.imageBackground,
                                                                                // Background color for error state.
                                                                                child: Center(
                                                                                  child: TextWhite(text: contentData.title),
                                                                                )
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        bottom: 0,
                                                                        left: 0,
                                                                        right: 0,
                                                                        height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              begin: Alignment.bottomCenter,
                                                                              end: Alignment.topCenter,
                                                                              colors: [
                                                                                Colors.black.withOpacity(0.85), // Start color
                                                                                Colors.transparent, // End color
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment: Alignment.bottomLeft,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(bottom: 4.0, right: 4, left: 4),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text(contentData.title,
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight
                                                                                      .bold,
                                                                                  color: Colors
                                                                                      .white,
                                                                                ),
                                                                              ),
                                                                              Text(contentData.casts,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    color: Colors.white,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Helper.dynamicHeight(context, 1),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                );
                              }
                              return Container();
                            },
                          )

                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),


      ),
    );
  }
}
