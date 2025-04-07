import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';

class RoomPlayer extends StatefulWidget {
  Map map;
  RoomPlayer({super.key, required this.map});

  @override
  State<RoomPlayer> createState() => _RoomPlayerState();
}

class _RoomPlayerState extends State<RoomPlayer> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String? _currentlyPlayingUrl;
 // FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;
  var time = 0;
  var forwardTime = 0;
  FlutterSoundRecorder? _recorder;

  BetterPlayerController? _betterPlayerController;
  @override
  void dispose() {
    _betterPlayerController?.pause();
    WakelockPlus.disable();
    _betterPlayerController?.videoPlayerController?.position.then((currentPosition) async {
      if (currentPosition != null) {
        Helper.movieRoomTime = currentPosition.inSeconds;
      }
      _betterPlayerController?.dispose();
      super.dispose();
    });



  }



  void _sendTextMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'type': 'text',
          'content': _messageController.text,
          'sender': 'You',
          'timestamp': DateTime.now().toString(),
        });
        _messageController.clear();
      });
    }
  }

  void _initializePlayer() {
    var key = widget.map["keyPairId"];
    var policy = widget.map["policy"];
    var signature = widget.map["signature"];
    final String cookies = 'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=$policy; CloudFront-Signature=$signature';

    try {
      BetterPlayerConfiguration betterPlayerConfiguration =
       BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        startAt: Duration(seconds: Helper.movieRoomTime),
        autoDispose: true,


        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(

          enableProgressBar: widget.map["owner"] == true ? true : false,
          enablePlayPause:  widget.map["owner"] == true ? true : false,
          enableSubtitles: true,
          enableFullscreen: true,
          progressBarPlayedColor: Colors.red,
          progressBarHandleColor: Colors.white,
          progressBarBackgroundColor: Colors.grey,
          enableSkips: widget.map["owner"] == true ? true : false,

        ),


      );

      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        // videoUrl,
        widget.map["url"],
        videoFormat: BetterPlayerVideoFormat.hls,
        headers: {
          'Cookie': cookies, // Add cookies here
        },
        subtitles: [
          for(int i=0; i<widget.map["captions"].length; i++)
            BetterPlayerSubtitlesSource(
              type: BetterPlayerSubtitlesSourceType.network,
              urls: [widget.map['captions'][i].captionFilePath],
              name: widget.map['captions'][i].captionFileName,
            ),
        ],
      );


      _betterPlayerController = BetterPlayerController(betterPlayerConfiguration)
        ..setupDataSource(dataSource)
        ..addEventsListener((event) {



          if (event.betterPlayerEventType == BetterPlayerEventType.controlsVisible) {
            if(widget.map["owner"] == false){
              _betterPlayerController?.setControlsVisibility(false);
            }
          }


          if(event.betterPlayerEventType == BetterPlayerEventType.progress){
            Duration? position = _betterPlayerController?.videoPlayerController?.value.position;
            if(time +1 == position?.inSeconds || time == position?.inSeconds){
              time = position!.inSeconds;

            }else{
              addFieldsToFirestore({
                "action": "Forward",
                "id" : widget.map['roomId'],
                "msg": "Forward",
                "videoTime" : position!.inSeconds,
                "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
                "userType":widget.map["owner"] == true ?  "Admin" :"User",
                "timestamp" : FieldValue.serverTimestamp()
              },widget.map['roomId']);
              time = position.inSeconds;
              return;
            }

            if(position.inSeconds % 5 == 0 && position.inSeconds != forwardTime){
              forwardTime = position.inSeconds;
              if(widget.map["owner"] == true){
                  addFieldsToFirestore({
                    "action": "Seek",
                    "id" : widget.map['roomId'],
                    "msg": "Seek",
                    "videoTime" : position.inSeconds,
                    "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
                    "userType":widget.map["owner"] == true ?  "Admin" :"User",
                    "timestamp" : FieldValue.serverTimestamp()
                  },widget.map['roomId']);
              }
            }

          }
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.exception) {
            debugPrint("Error initializing video Ebad: ${event.parameters}");
          }
          if(event.betterPlayerEventType == BetterPlayerEventType.play){
            if(widget.map["owner"] == true){
              addFieldsToFirestore({
                "action": "Play",
                "id" : widget.map['roomId'],
                "msg": "Play",
                "videoTime" : 0,
                "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
                "userType": widget.map["owner"] == true ?  "Admin" :"User",
                "timestamp" : FieldValue.serverTimestamp()
              },widget.map['roomId']);
            }

          }
          if(event.betterPlayerEventType == BetterPlayerEventType.pause){
            if(widget.map["owner"] == true){
              addFieldsToFirestore({
                "action": "Pause",
                "id" : widget.map['roomId'],
                "msg": "Pause",
                "videoTime" : 0,
                "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
                "userType": widget.map["owner"] == true ?  "Admin" :"User",
                "timestamp" : FieldValue.serverTimestamp()
              },widget.map['roomId']);
            }
          }

        });
    } catch (e) {
      debugPrint("Error initializing BetterPlayer Ebad: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WakelockPlus.enable();
    _initializePlayer();
    _recorder = FlutterSoundRecorder();
    _initRecorder();

  }

  Future<void> _initRecorder() async {
    listenForNewDocuments(widget.map['roomId']);

    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder!.openRecorder();
      _recorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
    } else {
      print("Microphone permission denied");
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    _audioPath = '${directory.path}/audio_message_$timestamp.aac';

    await _recorder!.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() => _isRecording = false);

    if (_audioPath != null) {
      File audioFile = File(_audioPath!);
      await _uploadAudioFile(audioFile);
    }
  }

  Future<void> _uploadAudioFile(File audioFile) async {
    try {
      String fileName = "audio_messages/${DateTime.now().millisecondsSinceEpoch}.aac";
      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage.ref(fileName).putFile(audioFile);

      // You can save `downloadUrl` in Firestore or use it as needed.
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Audio uploaded: $downloadUrl");
      addFieldsToFirestore({
        "action": "AUDIO",
        "id" : widget.map['roomId'],
        "msg": downloadUrl,
        "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
        "userType":widget.map["owner"] == true ?  "Admin" :"User",
        "videoTime" : time,
        "timestamp" : FieldValue.serverTimestamp()
      },widget.map['roomId']);


    } catch (e) {
      print("Audio upload failed: $e");
    }
  }

  Future<void> _playAudio(String audioUrl) async {
    AudioPlayer _audioPlayer = AudioPlayer();
    if (_currentlyPlayingUrl == audioUrl) {
      // Stop audio if it's already playing
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingUrl = null;
      });
    } else {
      // Stop any currently playing audio before starting new one
      if (_currentlyPlayingUrl != null) {
        await _audioPlayer.stop();
      }
      // Play new audio
      await _audioPlayer.play(DeviceFileSource(audioUrl));

      setState(() {
        _currentlyPlayingUrl = audioUrl;
      });
    }
  }

  // void _playAudio(String path) async {
  //   AudioPlayer audioPlayer = AudioPlayer();
  //   await audioPlayer.play(DeviceFileSource(path));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileScreenBackground,
      appBar: AppBar(
        title: Text(  widget.map["name"],
          style: TextStyle(
              color: Colors.white
          ),),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8.0),
        //     child: TextWhite(text: "End Room"),
        //   )
        // ],
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          BetterPlayer(
              controller: _betterPlayerController!
          ),
          Expanded(
           // flex: 6,
            child: Column(
              children: [
                Expanded(child:
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('NPLFLIX')
                      .doc(widget.map['roomId'].toString())
                      .collection("room")
                      .orderBy('timestamp', descending: true)// Latest first
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No messages yet."));
                    }

                    var messages = snapshot.data!.docs;
                    print("My messages $messages");

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        return message['action'] == 'TEXT' ||    message['action'] == "AUDIO" ? Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/png/person.png",color: AppColors.btnColor,height: 22,width: 22,),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.appBarColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(

                                                  child: Text(message['name'],style: TextStyle(color: Colors.white,fontSize: 14),)),
                                              Visibility(
                                                  visible: message['action'] == 'TEXT',
                                                  child: Text(message['msg'],style: TextStyle(color: Colors.white),)
                                              ),
                                              Visibility(
                                                  visible:  message['action'] == "AUDIO",
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      _playAudio(message['msg']);
                                                    },
                                                    child: Icon(_currentlyPlayingUrl ==  message['msg'] ? Icons.pause : Icons.play_arrow,color: Colors.white,),
                                                  )),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Text( message['timestamp'] != null ?Helper.getFormattedDate(message['timestamp']).toString() : "",style: TextStyle(color: Colors.white38,fontSize: 10),),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                             ],
                          ),
                        ) : Container();

                      },
                    );
                  },
                ),),
                Container(
                  color: AppColors.appBarColor,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0,right: 4,bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                            decoration: InputDecoration(hintText: 'Type a message',hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send,color: Colors.white,),
                          onPressed: (){
                            addFieldsToFirestore({
                              "action": "TEXT",
                              "id" : widget.map['roomId'],
                              "msg": _messageController.text.toString(),
                              "name": SharedPreferenceManager.sharedInstance.getString("userName").toString(),
                              "userType": widget.map["owner"] == true ?  "Admin" :"User",
                              "videoTime" : time,
                              "timestamp" : FieldValue.serverTimestamp()
                            },widget.map['roomId']);
                           // _sendTextMessage();
                            _messageController.clear();
                          },
                        ),
                        IconButton(
                          icon: Icon(_isRecording ? Icons.stop : Icons.mic,color: Colors.white,),
                          onPressed: _isRecording ? _stopRecording : _startRecording,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )

          ),
        ],
      ),
    );
  }



  Future<void> addFieldsToFirestore(Map<String, dynamic> data,var roomId) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection("NPLFLIX");
      // Add a new document with auto-generated ID
      await collection.doc(roomId.toString()).collection("room").add(data);

      print("Document added successfully!");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  void listenForNewDocuments(var roomid) {
    FirebaseFirestore.instance
        .collection('NPLFLIX')
        .doc(roomid.toString())
        .collection("room")
        .orderBy('timestamp', descending: true) // Optional: order by timestamp or auto ID
        .snapshots() // Listen to real-time updates
        .listen((QuerySnapshot querySnapshot) {
      // Loop through each new document
      for (var doc in querySnapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          var documentData = doc.doc.data() as Map<String, dynamic>;
          // Process the added document data here
          if(documentData['action'] == "Pause"){
            _betterPlayerController?.videoPlayerController?.pause();
          }else if(documentData['action'] == "Play"){
            _betterPlayerController?.videoPlayerController?.play();
          } else if(documentData['action'] == "Forward"){
            _betterPlayerController?.videoPlayerController?.seekTo(Duration(seconds: documentData['videoTime']));
          } else if(documentData['action'] == "Seek"){
            print("Owner ${widget.map['owner']}");
            if(widget.map["owner"] != true){
              Duration? position = _betterPlayerController?.videoPlayerController?.value.position;
              if(documentData['videoTime'] != position?.inSeconds && documentData['videoTime'] != position!.inSeconds+1 && documentData['videoTime'] != position!.inSeconds-1){
                print("Ebad time update");
                _betterPlayerController?.videoPlayerController?.seekTo(Duration(seconds: documentData['videoTime']));

              }
            }
          }
        }
      }
    });
  }
  
}
