import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:npflix/ui/widgets/movie_item_tv.dart';
import 'package:provider/provider.dart';

import '../../../controller/list_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../models/content_model.dart';
import '../../../network_module/api_base.dart';
import '../../../routes/index.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/movie_item.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MylistTv extends StatefulWidget {
  const MylistTv({super.key});

  @override
  State<MylistTv> createState() => _MylistState();
}

class _MylistState extends State<MylistTv> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeScreen();

  }
  var isLoading = false;

  initializeScreen(){
    setState(() {
     isLoading = false;
    });
    Provider.of<ListController>(context, listen: false).getList();

  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2),top:  Helper.dynamicHeight(context, 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    TextHeading(text: AppLocalizations.of(context)!.my_list),
                  ],
                ),
              ),
              SizedBox(
                height: Helper.dynamicHeight(context, 2),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: AppColors.profileScreenBackground,
                      child: Padding(
                        padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
                        child: Consumer<ListController>(
                          builder: (context, controller, child) {
                            if (controller.contentList.status == Status.LOADING) {
                              return SizedBox(
                                  height: Helper.dynamicHeight(context, 60),
                                  child: const Center( child: CircularProgressIndicator())
                              );
                            } else if (controller.contentList.status == Status.NOINTERNET) {
                              return NoInternetScreen(
                                onPressed: (){
                                  Provider.of<ListController>(context, listen: false).getList();
                                },
                              );
                            } else if (controller.contentList.status == Status.ERROR) {
                              return ErrorScreen(
                                errorMessage: controller.contentList.message,
                                onRetry: (){
                                  Provider.of<ListController>(context, listen: false).getList();
                                },
                              );
                            } else if (controller.contentList.status == Status.COMPLETED) {
                              return controller.contentList.data.isNotEmpty ?
                              GridView.builder(
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
                              ):

                              Center(child: TextWhite(text: AppLocalizations.of(context)!.add_items_to_my_list_to_watch_later,));
                            }
                            return Container();
                          },
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
                )
              )
            ],
          )
      ),
    );
  }
}
