
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
import '../../../models/content_model.dart';
import '../../../models/download_progress_model.dart';
import '../../../network_module/api_base.dart';
import '../../../utils/custom_toast.dart';
import '../../widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailsTv extends StatefulWidget {
  Map map;
  MovieDetailsTv({super.key,required this.map});

  @override
  State<MovieDetailsTv> createState() => _MovieDetailsTvState();
}

class _MovieDetailsTvState extends State<MovieDetailsTv> {


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

  bool _showControls = true;
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
        body: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height:  Helper.dynamicHeight(context, 100),
                    width: Helper.dynamicWidth(context, 40),
                    child: Stack(
                      children: [
                        Container(
                          color: AppColors.appBarColor,
                          height:  Helper.dynamicHeight(context, 100),
                          width: Helper.dynamicWidth(context, 40),
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
                                              color: Colors.white10,
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12.0,right: 12,top: 12,bottom: 12),
                                            child: Icon(_trailerController.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                                          )
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ): const Center(child: CircularProgressIndicator()) :Stack(
                            children: [
                              SizedBox.expand(
                                  child: Image.network(  "${APIBase.baseImageUrl+contentDetail.uuid.toString()}/img-thumb-sm-v.jpg",fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child; // The image has finished loading.
                                      }
                                      return Container(
                                        color: AppColors.imageBackground, // Placeholder background color.
                                        child: Center(
                                          child:  TextWhite(text: contentDetail.title),
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
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left: 8.0,top: 4),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2.0,right: 2),
                                      child: Icon(Icons.arrow_back_outlined,color: AppColors.btnColor,),
                                    )),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Helper.dynamicHeight(context, 10),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                          child: PlanTextBold(text: contentDetail.title.toString(),fontSize: 20),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
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

                        Row(
                          children: [

                            Expanded(
                              flex: 1,
                                child: Padding(
                                  padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 1)),
                                  child: Center(
                                    child: ButtonTextIconWidget(
                                        onPressed: () async{
                                          if(isPlay){
                                            _trailerController.pause();
                                          }
                                          if(!isVideoFetched){
                                            isVideoFetched = true;
                                            await Provider.of<ContentController>(context, listen: false).getVideo(contentDetail.uuid);
                                            if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){

                                              Navigator.of(context)
                                                  .pushNamed(nplflixVideoPlayer,arguments: {
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
                            ),
                            Expanded(
                              flex: 1,
                              child:  Padding(
                                padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 1)),
                                child: Center(
                                  child: ButtonTextIconWidget(
                                      onPressed: () async{
                                        if(isPlay){
                                          _trailerController.pause();
                                        }

                                      },
                                      icon:  Icons.play_arrow,
                                      text: AppLocalizations.of(context)!.watch_trailer,
                                    color:  AppColors.appBarColor,
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                                child: Padding(
                                  padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 1),right: Helper.dynamicWidth(context, 2)),
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
                                                } else if (contentController.video.status == Status.ERROR) {
                                                  toastmsg.showToast(context, message: contentController.video.message);
                                                  isVideoFetched = false;
                                                } else if (contentController.video.status == Status.NOINTERNET) {
                                                  toastmsg.showToast(context, message: "Please check your internet connection.");
                                                  isVideoFetched = false;
                                                }
                                              }
                                            },
                                            icon: Icons.cloud_download,
                                            text: snapshot.data!.status.toString(),
                                            color: AppColors.appBarColor,
                                          ),
                                        );
                                      }
                                  )
                                  ,
                                ),)
                          ],
                        ),
                        // Padding(
                        //   padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                        //   child: Center(
                        //     child: ButtonTextIconWidget(
                        //         onPressed: () async{
                        //           if(isPlay){
                        //             _trailerController.pause();
                        //           }
                        //
                        //         },
                        //         icon:  Icons.play_arrow,
                        //         text: AppLocalizations.of(context)!.watch_trailer),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: Helper.dynamicHeight(context, 1),
                        // ),
                        // Padding(
                        //   padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                        //   child: Center(
                        //     child: ButtonTextIconWidget(
                        //         onPressed: () async{
                        //           if(isPlay){
                        //             _trailerController.pause();
                        //           }
                        //           if(!isVideoFetched){
                        //             isVideoFetched = true;
                        //             await Provider.of<ContentController>(context, listen: false).getVideo(contentDetail.uuid);
                        //             if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){
                        //
                        //               Navigator.of(context)
                        //                   .pushNamed(nplflixVideoPlayer,arguments: {
                        //                 "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                        //                 "name" : contentDetail.title,
                        //               }).then((value){
                        //                 isVideoFetched = false;
                        //                 if(isPlay){
                        //                   _trailerController.play();
                        //                 }
                        //               });
                        //             }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                        //               isVideoFetched = false;
                        //               toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                        //             } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                        //               isVideoFetched = false;
                        //               toastmsg.showToast(context, message: "Please check you internet connection.");
                        //             }
                        //           }
                        //
                        //         },
                        //         icon:  Icons.play_arrow,
                        //         text: AppLocalizations.of(context)!.play),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: Helper.dynamicHeight(context, 1),
                        // ),
                        // Padding(
                        //   padding:EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                        //   child: StreamBuilder<String>(
                        //       stream: context.read<DowloadController>().controller.stream,
                        //       initialData: AppLocalizations.of(context)!.download,
                        //       builder: (context, snapshot) {
                        //         if(isDownloadCheck){
                        //           context.read<DowloadController>().fileExists(contentDetail.title.toString().replaceAll(" ", "-")+"..m3u8");
                        //           isDownloadCheck = false;
                        //         }
                        //         return Center(
                        //           child: ButtonTextIconWidget(
                        //             onPressed: () async {
                        //               var map =  contentDetail.toJson();
                        //               if(!isVideoFetched){
                        //                 isVideoFetched = true;
                        //                 await Provider.of<ContentController>(context, listen: false).getVideo(contentDetail.uuid);
                        //                 if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){
                        //                   await  context.read<DowloadController>() .saveVideoAndMetadata(Provider.of<ContentController>(context, listen: false).video.data.videoUrl.toString(), "${APIBase.baseImageUrl+contentDetail.uuid}/img-thumb-sm-h.jpg",map,contentDetail.title.toString().replaceAll(" ", "-")+".m3u8");
                        //                 }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                        //                   toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                        //                   isVideoFetched = false;
                        //                 } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                        //                   toastmsg.showToast(context, message: "Please check you internet connection.");
                        //                   isVideoFetched = false;
                        //                 }
                        //               }
                        //             },
                        //             icon:  Icons.cloud_download,
                        //             text: snapshot.data.toString(),
                        //             color:  AppColors.appBarColor,
                        //           ),
                        //         );
                        //       }
                        //   ),
                        // ),
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
                                    onTap: (){
                                      toastmsg.showToast(context, message: "Feature will be available soon");
                                    },
                                    child:  Column(
                                      children: [
                                        Icon(Icons.edit,color: Colors.white,),
                                        TextWhite(text: AppLocalizations.of(context)!.create_seat)
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
                                      Icon(Icons.share,color : Colors.white, ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWhite(text: contentDetail.contentType != "Songs" ?  AppLocalizations.of(context)!.cast+":  " : AppLocalizations.of(context)!.singer+":  ",fontSize: 13,fontWeight: FontWeight.bold,),
                              TextWhite(text:  contentDetail.casts ,fontSize: 13,),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Helper.dynamicHeight(context, 0.5),
                        ),
                        Padding(
                          padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWhite(text: contentDetail.contentType != "Songs" ?  AppLocalizations.of(context)!.director+":  " : AppLocalizations.of(context)!.lyrics_by+":  ",fontSize: 13,fontWeight: FontWeight.bold,),
                              TextWhite(text: contentDetail.contentType != "Songs" ?  contentDetail.director : contentDetail.writer,fontSize: 13,),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Helper.dynamicHeight(context, 0.5),
                        ),
                        Padding(
                          padding:EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWhite(text: "${AppLocalizations.of(context)!.genre}:  ",fontSize: 13,fontWeight: FontWeight.bold,),
                              TextWhite(text: contentDetail.genre,fontSize: 13,),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Helper.dynamicHeight(context, 2),
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

