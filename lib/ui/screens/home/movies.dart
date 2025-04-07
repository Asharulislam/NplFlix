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

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesTvState();
}

class _MoviesTvState extends State<Movies> {
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
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2),top:  Helper.dynamicHeight(context, 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  TextHeading(text: AppLocalizations.of(context)!.movies),
                ],
              ),
            ),

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
                  return
                  Expanded(
                      child:
                      Container(
                        color: AppColors.profileScreenBackground,
                        child: ListView.builder(
                          // itemCount: moviesTypes.length,
                            itemCount: controller.homecontent.data
                                .where((home) => home.type == "Movies") // Filter HomeContent by type
                                .expand((home) => home.headingModel) // Flatten headingModel lists
                                .toList()
                                .length,
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              final filteredList = controller.homecontent.data
                                  .where((home) => home.type == "Movies") // Filter HomeContent by type
                                  .expand((home) => home.headingModel) // Flatten headingModel lists
                                  .toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Helper.dynamicHeight(context,4),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 1)),
                                    child:  PlanTextBold(text: filteredList[index].heading),
                                  ),
                                  SizedBox(
                                    height: Helper.dynamicHeight(context, 1),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2),),
                                    child: SizedBox(
                                      height: Helper.dynamicHeight(context, 25),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount : filteredList[index].headingContentModel.length,
                                          itemBuilder: (context,position){
                                            final Content contentData = controller.contentList.data.firstWhere(
                                                  (item) => item.uuid != null &&
                                                  item.uuid!.contains(filteredList[index].headingContentModel[position].uuid),
                                              orElse: () => Content(), // Provide a fallback if no match is found
                                            );
                                            return
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.of(context)
                                                      .pushNamed(movieDetails,arguments: {
                                                    "content" : controller.contentList.data[position]
                                                  });
                                                },
                                                child: Padding(
                                                  padding:  EdgeInsets.only(right:Helper.dynamicWidth(context, 1)),
                                                  child: Container(
                                                    width: Helper.dynamicWidth(context, 25),
                                                    // height: (Helper.dynamicWidth(context, 80) * 1.5),
                                                    // height: Helper.dynamicHeight(context, 90),
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
                                                    ),
                                                  ),
                                                ),
                                              );
                                          }
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }),
                      )
                    // Container(
                    //   color: AppColors.profileScreenBackground,
                    //   child: Padding(
                    //     padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2),),
                    //     child: ListView.builder(
                    //         itemCount: controller.homecontent.data
                    //             .where((home) => home.type == "Songs") // Filter HomeContent by type
                    //             .expand((home) => home.headingModel) // Flatten headingModel lists
                    //             .toList()
                    //             .length,
                    //         itemBuilder: (context,index){
                    //           final filteredList = controller.homecontent.data
                    //               .where((home) => home.type == "Songs") // Filter HomeContent by type
                    //               .expand((home) => home.headingModel) // Flatten headingModel lists
                    //               .toList();
                    //           return GridView.builder(
                    //         padding: const EdgeInsets.all(8.0),
                    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2, // Number of columns
                    //           crossAxisSpacing: 6.0,
                    //           mainAxisSpacing: 10.0,
                    //           childAspectRatio:  Helper.dynamicWidth(context, 45) / Helper.dynamicHeight(context, 15), // Maintain aspect ratio
                    //         ),
                    //
                    //         itemCount: filteredList[index].headingContentModel.length,
                    //         itemBuilder: (context, position) {
                    //
                    //           final Content contentData = controller.contentList.data.firstWhere(
                    //                 (item) => item.uuid != null &&
                    //                 item.uuid!.contains(filteredList[index].headingContentModel[position].uuid),
                    //             orElse: () => Content(), // Provide a fallback if no match is found
                    //           );
                    //
                    //           return InkWell(
                    //             onTap: (){
                    //               Navigator.of(context)
                    //                   .pushNamed(nplflixVideoPlayer,arguments: {
                    //                 "url" : "item.video",
                    //                 "name" : contentData.title,
                    //               });
                    //             },
                    //             child: SizedBox(
                    //               width: Helper.dynamicWidth(context, 50),
                    //               height: Helper.dynamicHeight(context, 15),
                    //               child: Stack(
                    //                 children: [
                    //                   // Background Image
                    //                   ClipRRect(
                    //                     borderRadius: BorderRadius.circular(5),
                    //                     child: Image.network("${APIBase.baseImageUrl+contentData.uuid}/img-thumb-sm-h.jpg",
                    //                      // item.smallImageHorizontal.toString().replaceAll("\r\n", ""),
                    //                       width: Helper.dynamicWidth(context, 43),
                    //                       height: Helper.dynamicHeight(context, 15),
                    //                       fit: BoxFit.cover, // Ensure the image covers the full area
                    //                     ),
                    //                   ),
                    //                   Align(
                    //                     alignment: Alignment.topCenter,
                    //                     child: Container(
                    //                       decoration: BoxDecoration(
                    //                         gradient: new LinearGradient(
                    //                           end: const Alignment(0.0, -1),
                    //                           begin: const Alignment(0.0, 0.6),
                    //                           colors: <Color>[
                    //                             const Color(0x8A000000),
                    //                             Colors.transparent.withOpacity(0.0)
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Align(
                    //                     alignment: Alignment.bottomCenter,
                    //                     child: Container(
                    //                       decoration: BoxDecoration(
                    //                         gradient: new LinearGradient(
                    //                           end: const Alignment(0.0, -1),
                    //                           begin: const Alignment(0.0, 0.6),
                    //                           colors: <Color>[
                    //                             const Color(0x8A000000),
                    //                             Colors.black26.withOpacity(0.0)
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   // Text Overlay
                    //                   Align(
                    //                     alignment: Alignment.bottomLeft,
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(left: 4.0,right: 4,bottom: 4),
                    //                       child: Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         mainAxisAlignment: MainAxisAlignment.start,
                    //                         mainAxisSize: MainAxisSize.min,
                    //                         children: [
                    //                           Text(
                    //                             contentData.title,
                    //                             textAlign: TextAlign.left,
                    //                             style: const TextStyle(
                    //                               fontSize: 13,
                    //                               fontWeight: FontWeight.bold,
                    //                               color: Colors.white,
                    //                             ),
                    //                           ),
                    //                           Text(
                    //                             contentData.casts,
                    //                             textAlign: TextAlign.left,
                    //                             style: const TextStyle(
                    //                               fontSize: 12,
                    //                               color: Colors.white,
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     })
                    //   )
                    // ),
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
