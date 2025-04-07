import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:npflix/ui/widgets/movie_item_tv.dart';
import 'package:npflix/ui/widgets/my_list_item.dart';
import 'package:provider/provider.dart';

import '../../../controller/content_controller.dart';
import '../../../controller/list_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../routes/index.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/movie_item.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Mylist extends StatefulWidget {
  const Mylist({super.key});

  @override
  State<Mylist> createState() => _MylistState();
}

class _MylistState extends State<Mylist> {
  bool isVideoFetched = false;
  var toastmsg = CustomToast.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeScreen();
    toastmsg.initialize(context);

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
                padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/png/barimg.png",width: 100,height: 42,),
                    TextHeading(text: AppLocalizations.of(context)!.my_list),
                  ],
                ),
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
                              return controller.contentList.data.isNotEmpty ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.contentList.data.length,
                                  itemBuilder: (context,index){
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.of(context)
                                                .pushNamed(movieDetails,arguments: {
                                              "content" : controller.contentList.data[index]
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              MyListItem(
                                                  id:  controller.contentList.data[index].uuid.toString(),
                                                  title: controller.contentList.data[index].title ,
                                                  year: Helper.getYearFromDate(controller.contentList.data[index].releaseDate),
                                                  details: controller.contentList.data[index].genre,
                                                  duration:  controller.contentList.data[index].duration,
                                                isFree: controller.contentList.data[index].isContentFree ?? false,
                                                onDetail: (){
                                                  Navigator.of(context)
                                                      .pushNamed(movieDetails,arguments: {
                                                    "content" : controller.contentList.data[index]
                                                  });
                                                },
                                                onPlay: () async{
                                                  if(!isVideoFetched){
                                                    isVideoFetched = true;
                                                    await Provider.of<ContentController>(context, listen: false).getVideo(controller.contentList.data[index].uuid);
                                                    if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){

                                                      Navigator.of(context)
                                                          .pushNamed(nplflixVideoPlayer,arguments: {
                                                        "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                                        "name" : controller.contentList.data[index].title,
                                                        'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                                        'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                                        'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                                        "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                                        "uuId" : controller.contentList.data[index].uuid,
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
                                                onRemove: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await Provider.of<ListController>(context, listen: false).removeList(controller.contentList.data[index].contentId,controller.contentList.data[index].uuid);
                                                  initializeScreen();
                                                },
                                              ),
                                              // Align(
                                              //   alignment: Alignment.bottomRight,
                                              //   child: Padding(
                                              //     padding:  EdgeInsets.only(top: Helper.dynamicHeight(context, 3)),
                                              //     child: InkWell(
                                              //         onTap: () async{
                                              //           setState(() {
                                              //             isLoading = true;
                                              //           });
                                              //           await Provider.of<ListController>(context, listen: false).removeList(controller.contentList.data[index].contentId,controller.contentList.data[index].uuid);
                                              //           initializeScreen();
                                              //
                                              //         },
                                              //         child: Container(
                                              //           decoration: BoxDecoration(
                                              //             color: Colors.white70,
                                              //             shape: BoxShape.circle,
                                              //           ),
                                              //           padding: EdgeInsets.all(1),
                                              //           child: Icon(Icons.remove, color: Colors.white,size: 20,),
                                              //         )
                                              //     ),
                                              //   ),
                                              // )

                                            ],
                                          ),
                                        )
                                    );
                                  }
                              ):  Center(child: TextWhite(text: AppLocalizations.of(context)!.add_items_to_my_list_to_watch_later,));
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
