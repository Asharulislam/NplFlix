import 'package:flutter/material.dart';
import 'package:npflix/controller/search_content_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:npflix/ui/widgets/movie_item_tv.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../models/content_model.dart';
import '../../../network_module/api_base.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/movie_item.dart';
import '../../widgets/no_internet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreenTv extends StatefulWidget {
  const SearchScreenTv({super.key});

  @override
  State<SearchScreenTv> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenTv> {
  TextEditingController searchTextController = TextEditingController();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchTextController.dispose();
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContent("");
    searchTextController.addListener((){
      if(searchTextController.text.length > 2){
        getContent(searchTextController.text.toString());
      }
      if(searchTextController.text.length<1){
        getContent("");
      }
    });
  }



  getContent(var text) async {
    await Provider.of<SearchContentController>(context, listen: false).searchContentList(text);
  }
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        // appBar: AppBar(
        //   backgroundColor: AppColors.backgroundColor,
        //   title:  TextHeading(text: AppLocalizations.of(context)!.search),
        //   iconTheme: const IconThemeData(color: AppColors.btnColor),
        //   //automaticallyImplyLeading: false,
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 1),top:  Helper.dynamicHeight(context, 2)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 60.0,
                color: AppColors.appBarColor, // Matches the dark theme
                child: TextField(
                  controller: searchTextController,
                  decoration:   InputDecoration(
                    labelText: AppLocalizations.of(context)!.search, // Label text
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      color: Colors.white, // Label text color
                      fontSize: 14,        // Label font size
                    ),
                    suffixIcon: Icon(
                      Icons.search, // Use email icon
                      color: AppColors.btnColor,
                      size: 26,// Icon color
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 1),top:  Helper.dynamicHeight(context, 2)),
              child:  PlanTextBold(text: AppLocalizations.of(context)!.top_search_results),
            ),
            SizedBox(
              height: Helper.dynamicHeight(context, 1),
            ),
            Expanded(
              child: Container(
                color: AppColors.profileScreenBackground,
                child: Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 1),top:  Helper.dynamicHeight(context, 2)),
                  child: Consumer<SearchContentController>(
                    builder: (context, controller, child) {
                      if (controller.contentList.status == Status.LOADING) {
                        return SizedBox(
                            height: Helper.dynamicHeight(context, 60),
                            child: const Center( child: CircularProgressIndicator())
                        );
                      } else if (controller.contentList.status == Status.NOINTERNET) {
                        return NoInternetScreen(
                          onPressed: (){
                            getContent("");
                          },
                        );
                      }else if (controller.contentList.status == Status.ERROR) {
                        return ErrorScreen(
                          errorMessage:controller.contentList.message,
                          onRetry: (){
                            getContent("");
                          },
                        );
                      } else if (controller.contentList.status == Status.COMPLETED) {
                        return GridView.builder(
                          // physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Number of columns
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.9, // Maintain aspect ratio
                          ),
                          itemCount: controller.contentList.data.length,
                          itemBuilder: (context, position) {
                            final Content contentData = controller.contentList.data[position];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  nplflixVideoPlayer,
                                  arguments: {
                                    "url": "item.video",
                                    "name": contentData.title,
                                  },
                                );
                              },
                              child: SizedBox(
                                width: Helper.dynamicWidth(context, 25),
                                height: Helper.dynamicHeight(context, 22),
                                child: Stack(
                                  children: [
                                    // Background Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        "${APIBase.baseImageUrl + contentData.uuid}/img-thumb-md-h.jpg",
                                        width: Helper.dynamicWidth(context, 25),
                                        height: Helper.dynamicHeight(context, 22),
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child; // The image has finished loading.
                                          }
                                          return Container(
                                              width: Helper.dynamicWidth(context, 25),
                                              height: Helper.dynamicHeight(context, 22),
                                              color: AppColors.imageBackground, // Placeholder background color.
                                              child: Center(
                                                child: TextWhite(text: contentData.title),
                                              )
                                          );
                                        },
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          return Container(
                                              width: Helper.dynamicWidth(context, 25),
                                              height: Helper.dynamicHeight(context, 22),
                                              color: AppColors.imageBackground, // Background color for error state.
                                              child: Center(
                                                child: TextWhite(text: contentData.title),
                                              )
                                          );
                                        },// Ensure the image covers the full area
                                      ),
                                    ),
                                    // Text Overlay
                                    // Gradient Overlay (Bottom 10%)
                                    Visibility(
                                      visible: contentData.contentType == "Songs",
                                      child: Positioned(
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
                                    ),
                                    Visibility(
                                      visible: contentData.contentType == "Songs",
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4, bottom: 2),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                contentData.title,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                contentData.casts,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        // return ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: controller.contentList.data.length,
                        //     itemBuilder: (context,index){
                        //       return   Padding(
                        //         padding: const EdgeInsets.only(bottom: 15.0),
                        //         child: InkWell(
                        //           onTap: (){
                        //             Navigator.of(context)
                        //                 .pushNamed(movieDetails,arguments: {
                        //               "content" : controller.contentList.data[index]
                        //             });
                        //           },
                        //           child: MovieItemTv(
                        //               id:  controller.contentList.data[index].uuid,
                        //               title: controller.contentList.data[index].title , year: Helper.getYearFromDate(controller.contentList.data[index].releaseDate), details: controller.contentList.data[index].genre,duration:  controller.contentList.data[index].duration),
                        //         ),
                        //       );
                        //     }
                        // );
                      }
                      return Container();
                    },
                  ),

                ),
              ),
            )

          ],
        )
      ),
    );
  }
}
