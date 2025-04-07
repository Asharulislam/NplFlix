import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:npflix/controller/content_controller.dart';
import 'package:npflix/controller/list_controller.dart';
import 'package:npflix/controller/watch_time_controller.dart';
import 'package:npflix/models/content_model.dart';
import 'package:npflix/ui/widgets/content_item.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../network_module/api_base.dart';
import '../../../routes/index.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/content_card.dart';
import '../../widgets/no_internet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tabList = [];
  var selectedIndex = 0;
  var toastmsg = CustomToast.instance;
  bool isListCheck = true;
  bool isVideoFetched = false;

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



    return SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(
                height: Helper.dynamicHeight(context, 1),
              ),
              Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                child: Row(
                  children: [
                    Image.asset("assets/images/png/barimg.png",width: 100,height: 42,),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            Navigator.of(context).pushNamed(searchScreen);
                          });
                        },
                        child: Image.asset("assets/images/png/search.png" , height: 28,width: 28,color:  Colors.white,)
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: Helper.dynamicHeight(context, 1),
              // ),
              Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 1)),
                child: SizedBox(
                  height:35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: tabList.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedIndex = index;
                            });

                          },
                          child: SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PlanTextBold(text: tabList[index],textAlign: TextAlign.left,),
                                SizedBox(
                                  width: 40,
                                  child: Divider(
                                    height: 4,
                                    thickness: 4,
                                    color:  selectedIndex == index ? AppColors.btnColor : AppColors.backgroundColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              const Divider(
                color: AppColors.appBarColor,
                height: 1,
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
                    return selectedIndex == 0 ? Expanded(
                      child: Container(
                        color: AppColors.profileScreenBackground,
                        width: Helper.dynamicWidth(context, 100),
                        child: SingleChildScrollView(
                            child:  Consumer<ContentController>(
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
                                else if (controller.contentList.status == Status.ERROR) {
                                  return Center(child: TextWhite(text: 'Error: ${controller.contentList.message}'));
                                }
                                else if (controller.contentList.status == Status.COMPLETED) {
                                  return   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        height: Helper.dynamicHeight(context, 32),
                                        child: Padding(
                                          padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),

                                          child: Stack(
                                            children: [
                                              InkWell(
                                               onTap: (){
                                                 Navigator.of(context)
                                                     .pushNamed(movieDetails,arguments: {
                                                   "content" : controller.contentList.data[5]
                                                 });
                                               },
                                                child: Card(
                                                  elevation: 2,
                                                  color: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Image.network(
                                                      "${APIBase.baseImageUrl+controller.contentList.data[5].uuid}/img-thumb-md-h.jpg",
                                                     // height: Helper.dynamicHeight(context, 30),
                                                      width: Helper.dynamicWidth(context, 100),
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                        if (loadingProgress == null) {
                                                          return child; // The image has finished loading.
                                                        }
                                                        return Container(
                                                          //height: Helper.dynamicHeight(context, 25),
                                                          width: Helper.dynamicWidth(context, 100),
                                                          color:  AppColors.imageBackground,// Placeholder background color.
                                                          child: Center(
                                                            child: TextWhite(text:  controller.contentList.data[5].title),
                                                          )
                                                        );
                                                      },
                                                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                        return Container(
                                                           // height: Helper.dynamicHeight(context, 30),
                                                            width: Helper.dynamicWidth(context, 100),
                                                            color: AppColors.imageBackground, // Background color for error state.
                                                            child: Center(
                                                              child: TextWhite(text: controller.contentList.data[5].title),
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 3)),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2)),
                                                                child: ButtonTextIconWidget(
                                                                    onPressed: () async{
                                                                      if(!isVideoFetched){
                                                                        isVideoFetched = true;
                                                                        await Provider.of<ContentController>(context, listen: false).getVideo(controller.contentList.data[5].uuid);
                                                                        if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){

                                                                          Navigator.of(context)
                                                                              .pushNamed(nplflixVideoPlayer,arguments: {
                                                                            "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                                                            "name" : controller.contentList.data[14].title,
                                                                            'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                                                            'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                                                            'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                                                            "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                                                            "uuId" : controller.contentList.data[14].uuid,
                                                                            'captions' : Provider.of<ContentController>(context, listen: false).video.data.captions != null ? Provider.of<ContentController>(context, listen: false).video.data.captions : []

                                                                          }).then((value){
                                                                            isVideoFetched = false;

                                                                          });
                                                                        }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                                                                          isVideoFetched = false;
                                                                          toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                                                                        } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                                                                          isVideoFetched = false;
                                                                          toastmsg.showToast(context, message: "Please check you internet connection.");
                                                                        }
                                                                      }
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
                                                                padding:EdgeInsets.only(right: Helper.dynamicWidth(context, 2)),
                                                                child: StreamBuilder<bool>(
                                                                    stream: context.read<ListController>().isInListController.stream,
                                                                    initialData: false,
                                                                    builder: (context, snapshot) {
                                                                      if(isListCheck){
                                                                        context.read<ListController>().checkList(controller.contentList.data[5].contentId);
                                                                        isListCheck = false;
                                                                      }
                                                                      return ButtonTextIconWidget(
                                                                        onPressed: () async {

                                                                          Navigator.of(context)
                                                                              .pushNamed(movieDetails,arguments: {
                                                                            "content" : controller.contentList.data[5]
                                                                          });
                                                                        },
                                                                        icon: Icons.info,
                                                                        text: AppLocalizations.of(context)!.details,
                                                                        color: AppColors.containerBackground
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Helper.dynamicHeight(context, 1) ,),
                                      ListView.builder(
                                          itemCount: controller.homecontent.data
                                               .where((home) => home.typeId.toString() == "1") // Filter HomeContent by type
                                               .expand((home) => home.headingModel) // Flatten headingModel lists
                                               .toList()
                                               .length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            final filteredList = controller.homecontent.data
                                                .where((home) => home.typeId.toString() == "1") // Filter HomeContent by type
                                                .expand((home) => home.headingModel) // Flatten headingModel lists
                                                .toList();
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2.5),right: Helper.dynamicHeight(context, 3)),
                                                  child:  PlanTextBold(text: filteredList[index].heading),
                                                ),
                                                SizedBox(
                                                  height: Helper.dynamicHeight(context, 1),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2),),
                                                  child: SizedBox(
                                                    height: filteredList[index].headingId.toString() != "11" ?
                                                    Helper.dynamicHeight(context, 20) : Helper.dynamicHeight(context, 15),
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                       // itemCount: controller.contentList.data.length,
                                                        itemCount : filteredList[index].headingContentModel.length,
                                                        itemBuilder: (context,position){
                                                          // Find the matching Content object where uuid exists
                                                          final Content contentData = controller.contentList.data.firstWhere(
                                                                (item) => item.uuid != null &&
                                                                item.uuid!.contains(filteredList[index].headingContentModel[position].uuid),
                                                            orElse: () => Content(), // Provide a fallback if no match is found
                                                          );
                                                          return Padding(
                                                            padding: EdgeInsets.only(right: Helper.dynamicHeight(context, 0)),
                                                            child: Card(
                                                              elevation: 2,
                                                              color: Colors.transparent,
                                                              child: filteredList[index].headingId.toString() != "11" ?
                                                              filteredList[index].headingId.toString() == "14" ?
                                                              ContentCard(imageUrl: "${APIBase.baseImageUrl+contentData.uuid}/img-thumb-sm-v.jpg", progress: Helper.getProgressPercentage(contentData.watchedTime, contentData.duration),
                                                                  title: contentData.title,
                                                                  onDetail: (){
                                                                    Navigator.of(
                                                                        context)
                                                                        .pushNamed(
                                                                        movieDetails,
                                                                        arguments: {
                                                                          "content": contentData
                                                                        });
                                                                  },
                                                                  onRemove: () {
                                                                    Helper.removeWatchDialog(context, contentData.title,
                                                                        onPress: ()  {
                                                                      Navigator.pop(context);
                                                                          removeWatch(contentData.uuid,contentData.contentId);
                                                                        });
                                                                    },
                                                                  onPlay: () async {
                                                                    if(!isVideoFetched){
                                                                      isVideoFetched = true;
                                                                      await Provider.of<ContentController>(context, listen: false).getVideo(contentData.uuid);
                                                                      if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){

                                                                        Navigator.of(context)
                                                                            .pushNamed(nplflixVideoPlayer,arguments: {
                                                                          "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                                                          "name" : contentData.title,
                                                                          'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                                                          'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                                                          'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                                                          "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                                                          "uuId" : contentData.uuid,
                                                                          'captions' : Provider.of<ContentController>(context, listen: false).video.data.captions != null ? Provider.of<ContentController>(context, listen: false).video.data.captions : []

                                                                        }).then((value){
                                                                          isVideoFetched = false;

                                                                        });
                                                                      }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                                                                        isVideoFetched = false;
                                                                        toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                                                                      } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                                                                        isVideoFetched = false;
                                                                        toastmsg.showToast(context, message: "Please check you internet connection.");
                                                                      }
                                                                    }
                                                                  }) :
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      Navigator.of(
                                                                          context)
                                                                          .pushNamed(
                                                                          movieDetails,
                                                                          arguments: {
                                                                            "content": contentData
                                                                          });
                                                                    },
                                                                    child: ContentItem(imageUrl: "${APIBase.baseImageUrl+contentData.uuid}/img-thumb-sm-v.jpg",
                                                                        title: contentData.title, isFree: contentData.isContentFree),
                                                                  )
                                                                  :
                                                              GestureDetector(
                                                                onTap: (){
                                                                  Navigator.of(
                                                                      context)
                                                                      .pushNamed(
                                                                      movieDetails,
                                                                      arguments: {
                                                                        "content": contentData
                                                                      });
                                                                },
                                                                child: SizedBox(
                                                                  width: Helper.dynamicWidth(context, 45),
                                                                  height: Helper.dynamicHeight(context, 15),
                                                                  // Adjust as needed
                                                                  child: Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        child: Image.network(
                                                                          "${APIBase.baseImageUrl+contentData.uuid}/img-thumb-sm-h.jpg",
                                                                          width: Helper.dynamicWidth(context, 43),
                                                                          height: Helper.dynamicHeight(context, 15),
                                                                          // Same height
                                                                          fit: BoxFit.cover,
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
                                                                      // Align(
                                                                      //   alignment: Alignment.topCenter,
                                                                      //   child: Container(
                                                                      //     decoration: BoxDecoration(
                                                                      //       gradient: new LinearGradient(
                                                                      //         end: const Alignment(0.0, -1),
                                                                      //         begin: const Alignment(0.0, 0.6),
                                                                      //         colors: <Color>[const Color(0x8A000000),
                                                                      //           Colors.transparent.withOpacity(0.0)
                                                                      //         ],
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                      // Align(
                                                                      //   alignment: Alignment.bottomCenter,
                                                                      //   child: Container(
                                                                      //     decoration: BoxDecoration(
                                                                      //       gradient: new LinearGradient(
                                                                      //         end: const Alignment(0.0, -1),
                                                                      //         begin: const Alignment(0.0, 0.6),
                                                                      //         colors: <Color>[
                                                                      //           const Color(0x8A000000),
                                                                      //           Colors.black26.withOpacity(0.0)
                                                                      //         ],
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                      Align(
                                                                        alignment: Alignment.bottomCenter,
                                                                        child: Container(
                                                                          height: 30,
                                                                          width: Helper.dynamicWidth(context, 100),
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              end: const Alignment(0.0, -10),
                                                                              begin: const Alignment(0.0, -5.0),
                                                                              colors: <Color>[
                                                                                const Color(0x1F000000),
                                                                                Colors.black26.withOpacity(0.3),
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
                                                                      ),
                                                                      Visibility(
                                                                        visible: !contentData.isContentFree && SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "true",

                                                                        child: Positioned(
                                                                          top: 4,
                                                                          right: 10,
                                                                          left: 2,
                                                                          child: Row(
                                                                            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Spacer(),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.black38,
                                                                                    shape: BoxShape.circle,
                                                                                    border: Border.all(color: Colors.white,width: 2)

                                                                                ),
                                                                                padding: EdgeInsets.all(1),
                                                                                child: const Icon(Icons.diamond_outlined, color: Colors.white,size: 20,),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
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

                                    ],
                                  );
                                }
                                return Container();
                              },
                            )

                        ),
                      ),
                    ):
                    Expanded(
                        child: selectedIndex == 1 ?
                        Container(
                          color: AppColors.profileScreenBackground,
                          child: ListView.builder(
                             // itemCount: moviesTypes.length,
                              itemCount: controller.homecontent.data
                                  .where((home) => home.typeId.toString() == "2") // Filter HomeContent by type
                                  .expand((home) => home.headingModel) // Flatten headingModel lists
                                  .toList()
                                  .length,
                              shrinkWrap: true,
                             // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                final filteredList = controller.homecontent.data
                                    .where((home) => home.typeId.toString() == "2") // Filter HomeContent by type
                                    .expand((home) => home.headingModel) // Flatten headingModel lists
                                    .toList();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Helper.dynamicHeight(context, 1.5),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                                      child:  PlanTextBold(text: filteredList[index].heading),
                                    ),
                                    SizedBox(
                                      height: Helper.dynamicHeight(context, 0.2),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 2),),
                                      child: SizedBox(
                                        height: Helper.dynamicHeight(context, 20),
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
                                                      .pushNamed(movieDetails,
                                                      arguments: {
                                                        "content" : contentData
                                                      });
                                                },
                                                child: Padding(
                                                  padding:  EdgeInsets.only(right:Helper.dynamicHeight(context, 1)),
                                                  child: ContentItem(imageUrl: "${APIBase.baseImageUrl+contentData.uuid}/img-thumb-sm-v.jpg",
                                                      title: contentData.title, isFree: contentData.isContentFree),
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                    ),

                                  ],
                                );
                              }),
                        ) :
                        Container(
                          color: AppColors.profileScreenBackground,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Helper.dynamicHeight(context, 2),
                              right: Helper.dynamicHeight(context, 3),
                              top: Helper.dynamicHeight(context, 2),
                            ),
                            child: ListView.builder(
                              itemCount: controller.homecontent.data
                                  .where((home) => home.typeId.toString() == "6") // Filter HomeContent by type
                                  .expand((home) => home.headingModel) // Flatten headingModel lists
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                final filteredList = controller.homecontent.data
                                    .where((home) => home.typeId.toString() == "6") // Filter HomeContent by type
                                    .expand((home) => home.headingModel) // Flatten headingModel lists
                                    .toList();

                                return SizedBox(
                                  height: Helper.dynamicHeight(context, 90), // Adjust height as needed
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
                                    padding: const EdgeInsets.all(8.0),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing: 6.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: Helper.dynamicWidth(context, 45) /
                                          Helper.dynamicHeight(context, 15), // Maintain aspect ratio
                                    ),
                                    itemCount: filteredList[index].headingContentModel.length,
                                    itemBuilder: (context, position) {
                                      final Content contentData = controller.contentList.data.firstWhere(
                                            (item) =>
                                        item.uuid != null &&
                                            item.uuid!.contains(filteredList[index].headingContentModel[position].uuid),
                                        orElse: () => Content(), // Provide a fallback if no match is found
                                      );

                                      return InkWell(
                                        onTap: () async{
                                          Navigator.of(
                                              context)
                                              .pushNamed(
                                              movieDetails,
                                              arguments: {
                                                "content": contentData
                                              });
                                        },
                                        child: SizedBox(
                                          width: Helper.dynamicWidth(context, 50),
                                          height: Helper.dynamicHeight(context, 15),
                                          child: Stack(
                                            children: [
                                              // Background Image
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Image.network(
                                                  "${APIBase.baseImageUrl + contentData.uuid}/img-thumb-sm-h.jpg",
                                                  width: Helper.dynamicWidth(context, 43),
                                                  height: Helper.dynamicHeight(context, 15),
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      return child; // The image has finished loading.
                                                    }
                                                    return Container(
                                                      width: Helper.dynamicWidth(context, 43),
                                                      height: Helper.dynamicHeight(context, 15),
                                                      color: AppColors.imageBackground, // Placeholder background color.
                                                      child: Center(
                                                        child: TextWhite(text: contentData.title),
                                                      )
                                                    );
                                                  },
                                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                    return Container(
                                                        width: Helper.dynamicWidth(context, 43),
                                                        height: Helper.dynamicHeight(context, 15),
                                                        color: AppColors.imageBackground, // Background color for error state.
                                                        child: Center(
                                                          child: TextWhite(text: contentData.title),
                                                        )
                                                    );
                                                  },// Ensure the image covers the full area
                                                ),
                                              ),

                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  height: 30,
                                                  width: Helper.dynamicWidth(context, 100),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                       end: const Alignment(0.0, -10),
                                                       begin: const Alignment(0.0, -5.0),
                                                      colors: <Color>[
                                                        const Color(0x1F000000),
                                                        Colors.black26.withOpacity(0.3),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Text Overlay
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 4.0, right: 4, bottom: 4),
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
                                              Visibility(
                                                visible: !contentData.isContentFree && SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "true",

                                                child: Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  left: 2,
                                                  child: Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Spacer(),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black38,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Colors.white,width: 2)

                                                        ),
                                                        padding: EdgeInsets.all(1),
                                                        child: const Icon(Icons.diamond_outlined, color: Colors.white,size: 20,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
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
          )
      ),
    );
  }
  Future<void> removeWatch(var uuid,var contentid)async{
    await Provider.of<WatchTimeController>(context, listen: false).removeWatchTime(uuid,contentid);
    if(Provider.of<WatchTimeController>(context, listen: false).isRemove.status ==  Status.COMPLETED) {
      Helper.homecontentList.clear();
      await Provider.of<ContentController>(context, listen: false).fetchContentList();

    }else if(Provider.of<WatchTimeController>(context, listen: false).isRemove.status ==  Status.ERROR){
      toastmsg.showToast(context, message: Provider.of<WatchTimeController>(context, listen: false).isRemove.message);
    } else if(Provider.of<WatchTimeController>(context, listen: false).isRemove.status ==  Status.NOINTERNET){
      toastmsg.showToast(context, message: "Please check you internet connection.");
    }
  }
}
