import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:npflix/controller/manage_room_participants_controller.dart';
import 'package:npflix/enums/index.dart';
import 'package:npflix/models/room_model.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controller/content_controller.dart';
import '../../../controller/create_room_controller.dart';
import '../../../network_module/api_base.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RoomDetails extends StatefulWidget {
  Map map;
  RoomDetails({super.key,required this.map});

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  var toastmsg = CustomToast.instance;
  var dataLoad = true;
  late RoomModel roomModel;
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastmsg.initialize(context);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(dataLoad){
       roomModel = widget.map['roomDetails'];
       dataLoad = false;
       startCountdown(roomModel.roomStart);
    }

    return  Scaffold(
      backgroundColor: AppColors.profileScreenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.profileScreenBackground,
        title:  TextHeading(text: roomModel.roomName),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network( "${APIBase.baseImageUrl+roomModel.uuid.toString()}/img-thumb-md-h.jpg",
                  fit: BoxFit.fill,
                  width: Helper.dynamicWidth(context, 100),
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // The image has finished loading.
                    }
                    return Container(
                      color: AppColors.imageBackground, // Placeholder background color.
                      child: Center(
                        child: TextWhite(text: roomModel.roomName),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                        color: AppColors.imageBackground, // Background color for error state.
                        child: Center(
                          child: TextWhite(text:roomModel.roomName),
                        )
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
               // TextHeading(text: "${roomModel.roomName} Room Link:"),
                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                    child: Row(
                      children: [
                        const Expanded(

                            child: TextWhite(text: "Share your room link with others to join:",textAlign: TextAlign.start,fontSize: 18,)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: (){
                                  Share.share(roomModel.roomURL, subject: 'Please join my room');
                                },
                                child: Icon(Icons.share,color: Colors.white,))
                        )

                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ButtonWidget(
                    buttonWidth: 95,
                      onPressed: () async{

                      if(showTimer == "Play"){
                        setState(() {
                          isLoading = true;
                        });
                        await Provider.of<ContentController>(context, listen: false).getRoomVideo(roomModel.uuid,roomModel.roomUUID);
                        if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.COMPLETED){
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.of(context)
                              .pushNamed(roomPlayer,
                              arguments: {
                                "url" : Provider.of<ContentController>(context, listen: false).video.data.videoUrl,
                                "name" : roomModel.roomName,
                                "contentId" : roomModel.uuid,
                                'keyPairId' : Provider.of<ContentController>(context, listen: false).video.data.keyPairId,
                                'policy' : Provider.of<ContentController>(context, listen: false).video.data.policy,
                                'signature' : Provider.of<ContentController>(context, listen: false).video.data.signature,
                                "watchedTime" : Provider.of<ContentController>(context, listen: false).video.data.watchedTime ?? 0,
                                "uuId" : roomModel.uuid,
                                "roomId" : roomModel.roomUUID,
                                "owner" : isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),
                                'captions' : Provider.of<ContentController>(context, listen: false).video.data.captions != null ? Provider.of<ContentController>(context, listen: false).video.data.captions : []
                              }).then((value){

                          });


                        }else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.ERROR){
                          //isVideoFetched = false;
                          setState(() {
                            isLoading = false;
                          });
                          toastmsg.showToast(context, message: Provider.of<ContentController>(context, listen: false).video.message);
                        } else if(Provider.of<ContentController>(context, listen: false).video.status ==  Status.NOINTERNET){
                          //isVideoFetched = false;
                          setState(() {
                            isLoading = false;
                          });
                          toastmsg.showToast(context, message: "Please check you internet connection.");
                        }
                      }else{
                        toastmsg.showToast(context, message: "Please wait for the start time");

                      }

                      },
                      text: showTimer
                  ),
                ),
                const  SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),
                  child: Center(
                    child: ButtonTextIconWidget(
                      buttonWidth: 95,
                      onPressed: () => {
                        Helper.deleteRoom(context,roomModel.roomName,
                            onPress: (){
                              Navigator.pop(context);
                              deleteRoom(roomModel.roomUUID);
                            })
                      },
                      text: "Delete Room",
                      icon: Icons.delete,
                      color: AppColors.appBarColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),
                  child: Visibility(
                    visible: roomModel.participants.where((home) => home.roomMemberStatus.roomMemberStatusI == "Joined")  // Flatten headingModel lists
                        .toList()
                        .length > 1 ,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),

                      child: TextHeading(text: "Movie Partners"),
                    ),
                  ),
                ),

                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),
                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: roomModel.participants.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index){
                        Participant participant = roomModel.participants[index];
                          return  participant.roomMemberStatus.roomMemberStatusI == "Joined" ?  participant.isOwner ? Container() : Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex:8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(participant.joinAs,style: TextStyle(color: Colors.white,fontSize: 14),),
                                      Text(participant.email.toString(),style: TextStyle(color: Colors.grey,fontSize: 12),),
                                    ],
                                  ),
                                ),
                                 Expanded(
                                    flex:2,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                            onTap: (){
                                              declineParticipant(participant.userUUID, roomModel.roomUUID);
                                            },
                                            child: Icon(Icons.cancel_outlined,size: 28,color: Colors.white,))
                                    )
                                ),

                              ],
                            ),
                          ): Container();
                        }),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),

                  child: Visibility(
                    visible: roomModel.participants.where((home) => home.roomMemberStatus.roomMemberStatusI == "Pending")  // Flatten headingModel lists
                        .toList()
                        .length > 0,
                    child: Padding(
                      padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),

                      child: const TextHeading(text: "Pending Request"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isEmailInParticipantsWithStatus(roomModel.participants, SharedPreferenceManager.sharedInstance.getString("userEmail").toString(), true),

                  child: Padding(
                    padding:  EdgeInsets.only(left: Helper.dynamicWidth(context, 2),right: Helper.dynamicWidth(context, 2)),

                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: roomModel.participants.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index){
                          Participant participant = roomModel.participants[index];
                          return participant.roomMemberStatus.roomMemberStatusI == "Pending" ? Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex:6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(participant.joinAs,style: TextStyle(color: Colors.white,fontSize: 14),),
                                      Text(participant.email.toString(),style: TextStyle(color: Colors.grey,fontSize: 12),),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex:4,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Spacer(),
                                            GestureDetector(
                                                onTap: (){
                                                  approveParticipant(participant.userUUID, roomModel.roomUUID);
                                                },
                                                child: Icon(Icons.check,size: 28,color: Colors.white,)),
                                            const SizedBox(width: 15,),
                                            GestureDetector(
                                                onTap: (){
                                                  declineParticipant(participant.userUUID, roomModel.roomUUID);
                                                },
                                                child: Icon(Icons.cancel_outlined,size: 28,color: Colors.white,)),
                                          ],
                                        )
                                    )
                                ),

                              ],
                            ),
                          ): Container(
                            height: 0,
                          );
                        }),
                  ),
                ),


              ],
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
      ),
    );
  }


  //delete room before start the movie
  deleteRoom(var id) async{
    setState(() {
      isLoading = true;
    });
    await Provider.of<CreateRoomController>(context, listen: false).deleteRoomPost(id);
    if(Provider.of<CreateRoomController>(context, listen: false).deleteRoom.status == Status.COMPLETED){
      toastmsg.showToast(context, message: Provider.of<CreateRoomController>(context, listen: false).deleteRoom.data);
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }else if(Provider.of<CreateRoomController>(context, listen: false).deleteRoom.status == Status.ERROR){
      setState(() {
        isLoading = false;
      });
      toastmsg.showToast(context, message: Provider.of<CreateRoomController>(context, listen: false).deleteRoom.message);
    }
  }

  //approve user request for joining room
  approveParticipant(var userId, var roomId) async{
    setState(() {
      isLoading = true;
    });
    await Provider.of<ManageRoomParticipantsController>(context, listen: false).approveParticipant(userId,roomId);
    if(Provider.of<ManageRoomParticipantsController>(context, listen: false).approveParticipate.status == Status.COMPLETED){
      getRoom(roomId);
      toastmsg.showToast(context, message: Provider.of<ManageRoomParticipantsController>(context, listen: false).approveParticipate.data);
      setState(() {
        isLoading = false;
      });
    }else if(Provider.of<ManageRoomParticipantsController>(context, listen: false).approveParticipate.status == Status.ERROR){
      toastmsg.showToast(context, message: Provider.of<ManageRoomParticipantsController>(context, listen: false).approveParticipate.message);
      setState(() {
        isLoading = false;
      });
    }
  }

  var showTimer = "";
  void startCountdown(String targetTimeStr) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime targetTime = DateTime.parse(targetTimeStr);
      DateTime now = DateTime.now();

      // Ensure the target time is in the future
      if (targetTime.isBefore(now)) {
        timer.cancel();
        setState(() {
          showTimer = "Play"; // Or display "Event Started"
        });
        print("Event already started!");
        return;
      }

      Duration remainingDuration = targetTime.difference(now);

      Map<String, int> remainingTime = {
        'days': remainingDuration.inDays,
        'hours': remainingDuration.inHours % 24,
        'minutes': remainingDuration.inMinutes % 60,
        'seconds': remainingDuration.inSeconds % 60
      };

      // Build the time string dynamically, removing 0 values
      List<String> timeParts = [];
      if (remainingTime['days']! > 0) timeParts.add("${remainingTime['days']} d");
      if (remainingTime['hours']! > 0) timeParts.add("${remainingTime['hours']} h");
      if (remainingTime['minutes']! > 0) timeParts.add("${remainingTime['minutes']} m");
      if (remainingTime['seconds']! > 0) timeParts.add("${remainingTime['seconds']} s");

      setState(() {
        showTimer = timeParts.isNotEmpty ? "Remaining time: ${timeParts.join(', ')}" : "Play";
      });

      print(showTimer);
    });
  }



  //reject user request for joining room
  declineParticipant(var userId, var roomId) async{
    setState(() {
      isLoading = true;
    });
    await Provider.of<ManageRoomParticipantsController>(context, listen: false).blockParticipant(userId,roomId,"");
    if(Provider.of<ManageRoomParticipantsController>(context, listen: false).blockParticipate.status == Status.COMPLETED){
      getRoom(roomId);
      toastmsg.showToast(context, message: Provider.of<ManageRoomParticipantsController>(context, listen: false).blockParticipate.data);

      setState(() {
        isLoading = false;
      });
    }else if(Provider.of<ManageRoomParticipantsController>(context, listen: false).blockParticipate.status == Status.ERROR){
      getRoom(roomId);
      toastmsg.showToast(context, message: Provider.of<ManageRoomParticipantsController>(context, listen: false).blockParticipate.message);
      setState(() {
        isLoading = false;
      });
    }
  }


  getRoom(var roomId) async{
    await Provider.of<ManageRoomParticipantsController>(context, listen: false).getParticipateList(roomId);
    if(Provider.of<ManageRoomParticipantsController>(context, listen: false).getParticipate.status == Status.COMPLETED){

      setState(() {
        roomModel = Provider.of<ManageRoomParticipantsController>(context, listen: false).getParticipate.data;
      });

    }
  }


  bool isEmailInParticipantsWithStatus(
      List<Participant> participants, String email, bool isOwner) {
    return participants.any((participant) =>
    participant.email.toLowerCase() == email.toLowerCase() &&
        participant.isOwner == isOwner);
  }

}
