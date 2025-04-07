import 'package:flutter/material.dart';
import 'package:npflix/controller/create_room_controller.dart';
import 'package:npflix/models/room_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../enums/status_enum.dart';
import '../../../network_module/api_base.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/error_screen.dart';
import '../../widgets/no_internet_screen.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class RoomList extends StatefulWidget {

  RoomList({super.key});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileScreenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title:  TextHeading(text: AppLocalizations.of(context)!.movie_rooms),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2),top: Helper.dynamicHeight(context, 3)),
        child: Consumer<CreateRoomController>(
            builder: (context, controller, child){
              if (controller.getRooms.status == Status.LOADING) {
                return SizedBox(
                    height: Helper.dynamicHeight(context, 60),
                    child: const Center( child: CircularProgressIndicator())
                );
              }else if (controller.getRooms.status == Status.NOINTERNET) {
                return NoInternetScreen(
                  onPressed: (){
                    getRooms();
                  },
                );
              } else if (controller.getRooms.status == Status.ERROR) {
                return Center(
                  child: TextWhite(text: controller.getRooms.message.toString(),)
                );
              }else if(controller.getRooms.status == Status.COMPLETED){
                return  ListView.builder(
                  itemCount:  controller.getRooms.data.length,
                    itemBuilder: (context,index){
                    RoomModel roomModel = controller.getRooms.data[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context)
                            .pushNamed(roomDetails, arguments: {"roomDetails": roomModel}).then((val){
                              getRooms();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //  Image.asset(image,height: 90,width: 160,),
                            SizedBox(
                              height: 90,
                              width: 160,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      "${APIBase.baseImageUrl+roomModel.uuid}/img-thumb-sm-h.jpg",
                                      height: 90,
                                      width: 160,
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // The image has finished loading.
                                        }
                                        return Container(
                                          height: 90,
                                          width: 160,
                                          color: AppColors.imageBackground, // Placeholder background color.
                                          child: Center(
                                              child: TextWhite(text: roomModel.roomName)
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                        return Container(
                                            height: 90,
                                            width: 160,
                                            color: AppColors.imageBackground, // Background color for error state.
                                            child: Center(
                                              child: TextWhite(text: roomModel.roomName),
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            SizedBox(
                              width: Helper.dynamicWidth(context, 2),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextWhite(text:  roomModel.roomName,textAlign: TextAlign.start,fontSize: 16,),
                                        SizedBox(
                                          height: Helper.dynamicWidth(context, 1),
                                        ),
                                        PlanText(text: Helper.getOrderFormattedDate(roomModel.roomStart)),
                                        SizedBox(
                                          height: Helper.dynamicWidth(context, 1),
                                        ),
                                        PlanText(text: Helper.getOrderFormattedTime(roomModel.roomStart)),
                                        SizedBox(
                                          height: Helper.dynamicWidth(context, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(

                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Share.share(roomModel.roomURL, subject: 'Please join my room');

                                        },
                                        child: Icon(Icons.share, color: Colors.white,size: 28,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                });
              }
              return Container();
        })
      ),
    );
  }
  getRooms() async{
    await Provider.of<CreateRoomController>(context, listen: false).getRoomList();
  }
}
