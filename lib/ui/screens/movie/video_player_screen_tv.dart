
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../controller/watch_time_controller.dart';


class VideoPlayerScreenTv extends StatefulWidget {
  Map map;
  VideoPlayerScreenTv({Key? key, required this.map}) : super(key: key);

  @override
  State<VideoPlayerScreenTv> createState() => _VideoPlayerScreenTvState();
}

BetterPlayerController? _betterPlayerController;
class _VideoPlayerScreenTvState extends State<VideoPlayerScreenTv> {

  late WatchTimeController _watchTimeController;
  @override
  void dispose() {
    _betterPlayerController?.pause();
    WakelockPlus.disable();
    _betterPlayerController?.videoPlayerController?.position.then((currentPosition) async {
      if (currentPosition != null) {
        print("Saved position: $currentPosition");

        // Save time without using `context`
        await _watchTimeController.addWatchTime(widget.map["uuId"],widget.map["contentId"], currentPosition.inSeconds);
      }

      _betterPlayerController?.dispose(); // Dispose after saving time
      super.dispose(); // Now call super.dispose()
    });
  }


  void _initializePlayer() {
    var key = widget.map["keyPairId"];
    var policy = widget.map["policy"];
    var signature = widget.map["signature"];
    final String cookies = 'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=$policy; CloudFront-Signature=$signature';

    try {
      BetterPlayerConfiguration betterPlayerConfiguration =
       const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        autoDispose: true,


        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(

          enableProgressBar: true,
          enablePlayPause: true,
          enableSubtitles: true,
          enableFullscreen: true,
          progressBarPlayedColor: Colors.red,
          progressBarHandleColor: Colors.white,
          progressBarBackgroundColor: Colors.grey,
          enableSkips: true,

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
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.exception) {
            debugPrint("Error initializing video Ebad: ${event.parameters}");
          }

        });
    } catch (e) {
      debugPrint("Error initializing BetterPlayer Ebad: $e");
    }
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    WakelockPlus.enable();
    _initializePlayer();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.profileScreenBackground,
      appBar: AppBar(
        title: Text(  widget.map["name"],
          style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: GestureDetector(
        child: Center(
          child: BetterPlayer(
            controller: _betterPlayerController!
          ),
        ),
      ),
    );
  }
}


