
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npflix/controller/add_favorite_controller.dart';
import 'package:npflix/controller/dowload_controller.dart';
import 'package:npflix/enums/status_enum.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../controller/content_controller.dart';
import '../../../controller/list_controller.dart';
import '../../../controller/saveplan_controller.dart';
import '../../../models/content_model.dart';
import '../../../models/download_progress_model.dart';
import '../../../network_module/api_base.dart';
import '../../../sources/shared_preferences.dart';
import '../../../utils/custom_toast.dart';
import '../../widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetails extends StatefulWidget {
  Map map;
  MovieDetails({super.key,required this.map});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {


  @override
  void initState() {
    super.initState();
    toastmsg.initialize(context);
    getContent();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _trailerController.dispose();
    _hideControlsTimer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  var toastmsg = CustomToast.instance;
  late VideoPlayerController _trailerController;
  bool  isPlay = false;
  bool isPlayerIntitilize = false;
  var download = "Download";
  late Content contentDetail;
  bool isListCheck = true;
  bool isDownloadCheck = true;
  bool isVideoFetched = false;
  bool isLoading = false;

  bool _showControls = false;
  Timer? _hideControlsTimer;

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _resetHideControlsTimer();
      }
    });
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        _showControls = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    bool isFav = Helper.isFavList.contains(widget.map["content"].contentId.toString());
    //Content content = widget.map["content"];
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.details),
          iconTheme: const IconThemeData(color: Colors.white),
          //automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: Helper.dynamicWidth(context, 100) > 900 ? Helper.dynamicHeight(context, 50) :  Helper.dynamicHeight(context, 28),
                  child: Stack(
                    children: [
                      Container(
                        color: AppColors.appBarColor,
                        height: Helper.dynamicWidth(context, 100) > 850 ? Helper.dynamicHeight(context, 50) :  Helper.dynamicHeight(context, 28),
                        child: isPlay ?
                        isPlayerIntitilize ?
                        GestureDetector(
                          onTap: _toggleControlsVisibility,
                          child: Stack(
                            children: [
                              SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _trailerController.value.size.width,
                                    height: _trailerController.value.size.height,
                                    child: VideoPlayer(_trailerController),
                                  ),
                                ),
                              ),
                              if (_showControls)
                              Center(
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _trailerController.value.isPlaying ?
                                        _trailerController.pause() :
                                        _trailerController.play();
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.circular(100),
                                          border: Border.all(color: Colors.white,width: 3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12.0,right: 12,top: 12,bottom: 12),
                                          child: Icon(_trailerController.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,size: 28,),
                                        )
                                    )
                                ),
                              ),
                          
                            ],
                          ),
                        ): const Center(child: CircularProgressIndicator()) :Stack(
                          children: [
                            SizedBox.expand(
                                child: Image.network( "${APIBase.baseImageUrl+contentDetail.uuid.toString()}/img-thumb-md-h.jpg",fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // The image has finished loading.
                                    }
                                    return Container(
                                      color: AppColors.imageBackground, // Placeholder background color.
                                      child: Center(
                                        child: TextWhite(text: contentDetail.title),
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Container(
                                        color: AppColors.imageBackground, // Background color for error state.
                                        child: Center(
                                          child: TextWhite(text: contentDetail.title),
                                        )
                                    );
                                  },
                                )
                            ),
                            Visibility(
                              visible: contentDetail.contentType != "Songs",
                              child: Center(
                                child: InkWell(
                                  onTap: (){
                                    if(!isLoading){
                                      if(!isPlay){
                                        setVideoPlayer();
                                      }
                                    }
                                  },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child:  Padding(
                                          padding: EdgeInsets.only(left: 12.0,right: 12,top: 4,bottom: 4),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.play_arrow,size: 32,color: Colors.white,),
                                              TextWhite(text: AppLocalizations.of(context)!.watch_trailer)
                                            ],
                                          ),
                                        )
                                    )
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: InkWell(
                      //       onTap: (){
                      //         Navigator.pop(context);
                      //       },
                      //       child:  Padding(
                      //         padding:  EdgeInsets.only(left: 8.0,top: 4),
                      //         child: Container(
                      //             decoration: BoxDecoration(
                      //               color: Colors.white70,
                      //                 borderRadius: BorderRadius.circular(4)
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(left: 2.0,right: 2),
                      //               child: Icon(Icons.arrow_back_outlined,color: AppColors.btnColor,),
                      //             )),
                      //       )
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 4),right: Helper.dynamicWidth(context, 4)),
                              child: PlanTextBold(text: contentDetail.title.toString(),fontSize: 20),
                            ),
                             Padding(
                               padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 4),right: Helper.dynamicWidth(context, 4)),
                               child: Row(
                                 children: [
                                   TextWhite(text: Helper.getYearFromDate(contentDetail.releaseDate).toString(),fontSize: 12,),
                                   SizedBox(
                                     width:  Helper.dynamicWidth(context, 2),
                                   ),
                                   Container(
                                       color: AppColors.appBarColor,
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 6.0,right: 6,top: 3,bottom: 3),
                                         child: TextWhite(text: contentDetail.pg,fontSize: 9,),
                                       )
                                   ),
                                   SizedBox(
                                     width:  Helper.dynamicWidth(context, 2),
                                   ),
                                   TextWhite(text: Helper.formatDuration(contentDetail.duration),fontSize: 12,),
                                   SizedBox(
                                     width:  Helper.dynamicWidth(context, 3),
                                   ),
                                 ],
                               ),
                             ),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 2),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 3)),
                              child: Helper.isPlay(contentDetail.isContentFree ?? false, contentDetail.rentalTransaction)  ? Center(
                                child: ButtonTextIconWidget(
                                    onPressed: () async{
                                      if(isPlay){
                                        _trailerController.pause();
                                      }
                                      if(!isVideoFetched){
                                        isVideoFetched = true;
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await Provider.of<ContentController>(context, listen: false).getVideo(contentDetail.uuid);
                                        if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){
                                          setState(() {
                                            isLoading = false;
                                          });

                                          if(SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "true"){
                                            Navigator.of(context)
                                                .pushNamed(adPlayer,
                                                arguments: {
                                                  "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                                  "name" : contentDetail.title,
                                                  "contentId" : contentDetail.contentId,
                                                  'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                                  'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                                  'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                                  "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                                  "uuId" : contentDetail.uuid,
                                                  'captions' : Provider.of<ContentController>(context, listen: false).video.data.captions != null ? Provider.of<ContentController>(context, listen: false).video.data.captions : []
                                                }).then((value){
                                              isVideoFetched = false;
                                              if(isPlay){
                                                _trailerController.play();
                                              }
                                            });

                                          }else{
                                            Navigator.of(context)
                                                .pushNamed(nplflixVideoPlayer,
                                                arguments: {
                                                  "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                                  "name" : contentDetail.title,
                                                  "contentId" : contentDetail.contentId,
                                                  'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                                  'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                                  'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                                  "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                                  "uuId" : contentDetail.uuid,
                                                  'captions' : Provider.of<ContentController>(context, listen: false).video.data.captions != null ? Provider.of<ContentController>(context, listen: false).video.data.captions : []
                                                }).then((value){
                                              isVideoFetched = false;
                                              if(isPlay){
                                                _trailerController.play();
                                              }
                                            });
                                          }

                                        }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                                          isVideoFetched = false;
                                          setState(() {
                                            isLoading = false;
                                          });
                                          toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                                        } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                                          isVideoFetched = false;
                                          setState(() {
                                            isLoading = false;
                                          });
                                          toastmsg.showToast(context, message: "Please check you internet connection.");
                                        }
                                      }

                                    },
                                    icon:  Icons.play_arrow,
                                    text: contentDetail.watchedTime != null && contentDetail.watchedTime != 0  ? AppLocalizations.of(context)!.resume : AppLocalizations.of(context)!.play),
                              ): Center(
                                child: ButtonTextIconWidget(
                                    onPressed: () async{
                                      Helper.rentDialog(context, contentDetail.title,
                                          contentDetail.pricePerDay,contentDetail.discountPerDay,
                                          onPress: (selectedOption) async {
                                            print("User selected: $selectedOption");
                                            setState(() {
                                              isLoading = true;
                                            });


                                            await Provider.of<SaveplanController>(context, listen: false).payRentalPlan(contentDetail.uuid,selectedOption == 1 ? DateTime.now().add(Duration(days: 1)):  DateTime.now().add(Duration(days: 7)),
                                            selectedOption == 1 ? 1 : 7,contentDetail.pricePerDay,contentDetail.discountPerDay,
                                                selectedOption == 1 ? Helper.calculateRent(contentDetail.pricePerDay, contentDetail.discountPerDay, 1) : Helper.calculateRent(contentDetail.pricePerDay, contentDetail.discountPerDay, 7)
                                            );


                                            if(Provider.of<SaveplanController>(context, listen: false).savePlan.status == Status.COMPLETED){
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Helper.successDialog(
                                                  context, Provider.of<SaveplanController>(context, listen: false).savePlan.data.message,
                                                  onPress: (){
                                                    Navigator.pop(context);

                                                  });
                                            }else if(Provider.of<SaveplanController>(context, listen: false).savePlan.status == Status.ERROR){
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

                                            // Handle selected option (1 for Quick Watch, 2 for Weekly)
                                          });

                                    },
                                    icon:  Icons.account_balance_wallet,
                                    text: AppLocalizations.of(context)!.rent_now),
                              ),
                            ),

                            SizedBox(
                              height: Helper.dynamicHeight(context, 1),
                            ),
                            Visibility(
                              visible: contentDetail.isDownloadable,
                              child: Padding(
                                padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 3)),
                                child: StreamBuilder<DownloadProgressModel>(
                                    stream: context.read<DowloadController>().getController(
                                        contentDetail.title.toString().replaceAll(" ", "-") + ".m3u8"
                                    ).stream,
                                    initialData: DownloadProgressModel(
                                      status: AppLocalizations.of(context)!.download,
                                      videoFile: contentDetail.title.toString().replaceAll(" ", "-") + ".m3u8",
                                    ),
                                    builder: (context, snapshot) {
                                      if (isDownloadCheck) {
                                        context.read<DowloadController>().fileExists(
                                            contentDetail.title.toString().replaceAll(" ", "-") + ".m3u8"
                                        );
                                        isDownloadCheck = false;
                                      }
                                      return Center(
                                        child: ButtonTextIconWidget(
                                          onPressed: () async {

                                            if(snapshot.data!.status.toString() != "Downloaded"){
                                              var map = contentDetail.toJson();
                                              if (!isVideoFetched) {
                                                isVideoFetched = true;
                                                await Provider.of<ContentController>(context, listen: false)
                                                    .getVideo(contentDetail.uuid);
                                                var contentController = Provider.of<ContentController>(context, listen: false);
                                                if (contentController.video.status == Status.COMPLETED) {
                                                  var key = contentController.video.data.keyPairId.toString();
                                                  var policy = contentController.video.data.policy.toString();
                                                  var signature = contentController.video.data.signature.toString();
                                                  final String cookies = 'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=$policy; CloudFront-Signature=$signature';

                                                  await context.read<DowloadController>().saveVideoAndMetadata(
                                                      contentController.video.data.videoUrl.toString(),
                                                      "${APIBase.baseImageUrl + contentDetail.uuid}/img-thumb-sm-h.jpg",
                                                      map,
                                                      contentDetail.title.toString().replaceAll(" ", "-") + ".m3u8",
                                                      cookies
                                                  );
                                                  isVideoFetched = false;
                                                } else if (contentController.video.status == Status.ERROR) {
                                                  toastmsg.showToast(context, message: contentController.video.message);
                                                  isVideoFetched = false;
                                                } else if (contentController.video.status == Status.NOINTERNET) {
                                                  toastmsg.showToast(context, message: "Please check your internet connection.");
                                                  isVideoFetched = false;
                                                }
                                              }
                                            }else{
                                              print("Already Downloaded video");
                                              Navigator.of(context)
                                                  .pushNamed(downloadVideoPlayer,arguments: {
                                                "url" : "${contentDetail.title.toString().replaceAll(" ", "-") + ".m3u8"}",
                                                "name" : contentDetail.title,
                                              });
                                            }

                                          },
                                          icon: Icons.cloud_download,
                                          text: snapshot.data!.status.toString(),
                                          color: AppColors.appBarColor,
                                        ),
                                      );
                                    }
                                )

                              ),
                            ),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 2),
                            ),
                              //child:
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async{
                                          await Provider.of<ListController>(context, listen: false).addList(contentDetail.contentId,contentDetail.uuid);
                                        },
                                        child: StreamBuilder<bool>(
                                            stream: context.read<ListController>().isInListController.stream,
                                            initialData: false,
                                            builder: (context, snapshot) {
                                             if(isListCheck){
                                               context.read<ListController>().checkList(contentDetail.contentId);
                                               isListCheck = false;
                                             }
                                              return Column(
                                                children: [
                                                  Icon(snapshot.data == true ? Icons.check : Icons.add,color: Colors.white,),
                                                  TextWhite(text: AppLocalizations.of(context)!.my_list)
                                                ],
                                              );
                                            }
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async{
                                          if(!isLoading){
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await Provider.of<AddFavoriteController>(context, listen: false).likeContent(contentDetail.contentId,contentDetail.uuid, contentDetail.isLiked != null ? contentDetail.isLiked ? false : true: true);
                                            if(Provider.of<AddFavoriteController>(context, listen: false).contentList.status == Status.COMPLETED){
                                              getContent();
                                            }else if (Provider.of<AddFavoriteController>(context, listen: false).contentList.status == Status.ERROR){
                                              setState(() {
                                                isLoading = false;
                                              });
                                              toastmsg.showToast(context, message: Provider.of<AddFavoriteController>(context, listen: false).contentList.message);
                                            }
                                          }

                                        },
                                        child: Column(
                                          children: [
                                            Icon( contentDetail.isLiked != null ? contentDetail.isLiked ? Icons.thumb_up :Icons.thumb_up_alt_outlined : Icons.thumb_up_alt_outlined,color: Colors.white, ),
                                            TextWhite(text: AppLocalizations.of(context)!.like)
                                          ],
                                        ),
                                      )
                                  ),
                                  Visibility(
                                    visible: contentDetail.contentType != "Songs",
                                    child: Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () async {
                                            if(contentDetail.room == null){
                                              Navigator.of(context)
                                                  .pushNamed(createRoom,arguments: { "id" : contentDetail.uuid, "name" : contentDetail.title});
                                            }else{
                                              Navigator.of(context)
                                                  .pushNamed(roomDetails, arguments: {"roomDetails": contentDetail.room});
                                            }
                                          },
                                          child:  Column(
                                            children: [
                                              Icon( contentDetail.room == null ? Icons.edit : Icons.remove_red_eye,color: Colors.white,),
                                              TextWhite(text: contentDetail.room == null ? AppLocalizations.of(context)!.create_seat : "View Room")
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: (){
                                          toastmsg.showToast(context, message: "Feature will be available soon");
                                        },
                                        child: Column(
                                          children: [
                                            const Icon(Icons.share,color : Colors.white, ),
                                            TextWhite(text: AppLocalizations.of(context)!.share)
                                          ],
                                        ),
                                      )
                                  ),

                                ],
                              ),
                            //),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 3),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),

                              child:  TextWhite(text: contentDetail.synopsis.toString().replaceAll("\n", ""),fontSize: 12,textAlign: TextAlign.left,),
                            ),

                            SizedBox(
                              height: Helper.dynamicHeight(context, 2),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextWhite(text: contentDetail.contentType != "Songs" ?  AppLocalizations.of(context)!.cast+":  " : AppLocalizations.of(context)!.singer+":  ",fontSize: 13,fontWeight: FontWeight.bold,),
                                  Flexible(child: TextWhite(text:  contentDetail.casts ,fontSize: 13,textAlign: TextAlign.start,)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 0.5),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextWhite(text: contentDetail.contentType != "Songs" ?  AppLocalizations.of(context)!.director+":  " : AppLocalizations.of(context)!.lyrics_by+":  ",fontSize: 13,fontWeight: FontWeight.bold,),
                                  Flexible(child: TextWhite(text: contentDetail.contentType != "Songs" ?  contentDetail.director : contentDetail.writer,fontSize: 13,textAlign: TextAlign.start,)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 0.5),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextWhite(text: "${AppLocalizations.of(context)!.genre}:  ",fontSize: 13,fontWeight: FontWeight.bold,),
                                  Flexible(child: TextWhite(text: contentDetail.genre,fontSize: 13,textAlign: TextAlign.start,)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Helper.dynamicHeight(context, 2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  getContent() async{
    setState(() {
      isLoading = true;
    });
    contentDetail =  widget.map["content"];
    await Provider.of<ContentController>(context, listen: false).getContentById(widget.map["content"].uuid.toString());
    if(Provider.of<ContentController>(context, listen: false).content.status == Status.COMPLETED){
      setState(() {
        contentDetail =  Provider.of<ContentController>(context, listen: false).content.data;
        isLoading = false;
      });
    }
  }

  setVideoPlayer(){
    WakelockPlus.enable();
    print("Url: ${APIBase.baseImageUrl}${contentDetail.uuid}/trailers/${contentDetail.trailer1}");
    setState(() {
      isPlay = true;
    });

   _trailerController = VideoPlayerController.networkUrl(Uri.parse("${APIBase.baseImageUrl}${contentDetail.uuid}/trailers/${contentDetail.trailer1}"))
  //  _trailerController = VideoPlayerController.networkUrl(Uri.parse("https://d2hlypqiuqwyxh.cloudfront.net/d8037f38-a1e3-495c-95c1-9f815cae72bb/trailers/1080.m3u8"))
      ..initialize().then((_) {
        // Play the video after initialization


        _trailerController.play();
        // Make the video loop (optional)
        _trailerController.setLooping(false);
        setState(() {
          isPlayerIntitilize = true;
        });
      });
  }
}

