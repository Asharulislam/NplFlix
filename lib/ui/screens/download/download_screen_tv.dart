import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/download_movie_item.dart';
import 'package:npflix/ui/widgets/movie_item.dart';
import 'package:npflix/ui/widgets/no_internet_screen.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../controller/dowload_controller.dart';
import '../../../enums/status_enum.dart';
import '../../../routes/index.dart';
import '../../../utils/helper_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DownloadScreenTv extends StatefulWidget {
  const DownloadScreenTv({super.key});

  @override
  State<DownloadScreenTv> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreenTv> {


  var isMyListSelected = true;
  var isListLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeScreen();
  }

  initializeScreen(){
    Provider.of<DowloadController>(context, listen: false).getDownloadedVideos();
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
                  const Spacer(),
                  TextHeading(text: AppLocalizations.of(context)!.downloaded),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.profileScreenBackground,
                child: Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
                  child: Consumer<DowloadController>(
                    builder: (context, controller, child) {
                      if (controller.listDownload.status == Status.LOADING) {
                        return SizedBox(
                            height: Helper.dynamicHeight(context, 60),
                            child: const Center( child: CircularProgressIndicator())
                        );
                      } else if (controller.listDownload.status == Status.ERROR) {
                        return Center(child: TextWhite(text: '${controller.listDownload.message}'));
                      } else if (controller.listDownload.status == Status.COMPLETED) {
                        return  controller.listDownload.data.length > 0 ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listDownload.data.length,
                            itemBuilder: (context,index){
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.of(context)
                                          .pushNamed(downloadVideoPlayer,arguments: {
                                        "url" : controller.listVideos.data[index],
                                        "name" : controller.listDownload.data[index].title,
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        DownloadMovieItem(
                                            image: controller.listVideos.data[index].replaceAll(".m3u8", "_image.jpg"),
                                            title: controller.listDownload.data[index].title , year: Helper.getYearFromDate(controller.listDownload.data[index].releaseDate),
                                            details: controller.listDownload.data[index].genre,
                                            duration:  int.parse(controller.listDownload.data[index].duration.toString()),
                                          onPlay: (){
                                            Navigator.of(context)
                                                .pushNamed(downloadVideoPlayer,arguments: {
                                              "url" : controller.listVideos.data[index],
                                              "name" : controller.listDownload.data[index].title,
                                            });
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding:  EdgeInsets.only(top: Helper.dynamicHeight(context, 4)),
                                            child: InkWell(
                                                onTap: () async{
                                                  Helper.deleteDialog(context, controller.listDownload.data[index].title.toString(),
                                                      onPress: (){
                                                    Provider.of<DowloadController>(context, listen: false).deleteVideoAndMetadata(controller.listDownload.data[index].title.toString().replaceAll(" ", "-")+".m3u8");
                                                    Navigator.pop(context);
                                                  });



                                                },
                                                child: Icon(Icons.delete,color:  Colors.grey,)
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  )
                              );
                            }
                        ): Container(
                          child: TextWhite(text: AppLocalizations.of(context)!.no_downloaded_videos,),
                        );
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
