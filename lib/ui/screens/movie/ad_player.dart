import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npflix/controller/watch_time_controller.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';

class AdPlayer extends StatefulWidget {
  final Map map;
  AdPlayer({Key? key, required this.map}) : super(key: key);

  @override
  State<AdPlayer> createState() => _AdPlayerState();
}

class _AdPlayerState extends State<AdPlayer> {
  BetterPlayerController? _betterPlayerController;
  BetterPlayerController? _adPlayerController;
  List<int> adTimes = [1, 60]; // Ad times in seconds
  bool isAdPlaying = false;
  Set<int> playedAds = {};
  late WatchTimeController _watchTimeController;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initializePlayer();
    //_setLandscapeOrientation();
  }

  @override
  void dispose() {
    _betterPlayerController?.pause();
    WakelockPlus.disable();
    _betterPlayerController?.videoPlayerController?.position.then((currentPosition) async {
      if (currentPosition != null) {
        print("Saved position: $currentPosition");
        await _watchTimeController.addWatchTime(widget.map["uuId"], widget.map["contentId"], currentPosition.inSeconds);
      }
      _betterPlayerController?.dispose();
      _adPlayerController?.dispose();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      super.dispose();
    });
  }

  // void _setLandscapeOrientation() {
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.landscapeLeft,
  //   //   DeviceOrientation.landscapeRight,
  //   // ]);
  // }

  void _initializePlayer() {
    _watchTimeController = Provider.of<WatchTimeController>(context, listen: false);

    var key = widget.map["keyPairId"];
    var policy = widget.map["policy"];
    var signature = widget.map["signature"];
    final String cookies = 'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=$policy; CloudFront-Signature=$signature';

    try {
      BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        //aspectRatio: 16 / 9,
        fit: BoxFit.cover,
        autoPlay: true,
        autoDispose: true,
        startAt: Duration(seconds: widget.map["watchedTime"] ?? 0),
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(

          enableProgressBar: true,
          enablePlayPause: true,
          enableSubtitles: true,
          enableFullscreen: false,
          progressBarPlayedColor: Colors.red,
          progressBarHandleColor: Colors.white,
          progressBarBackgroundColor: Colors.grey,
          enableSkips: true,

        ),
      );

      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.map["url"] ?? "",
        videoFormat: BetterPlayerVideoFormat.hls,
        drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.token,
          licenseUrl: "https://nplflix-content.bizalpha.ca/",
        ),
        headers: {'Cookie': cookies},
        subtitles: [
          for (int i = 0; i < (widget.map["captions"]?.length ?? 0); i++)
            BetterPlayerSubtitlesSource(
              type: BetterPlayerSubtitlesSourceType.network,
              urls: [widget.map['captions'][i].captionFilePath ?? ""],
              name: widget.map['captions'][i].captionFileName ?? "",
            ),
        ],
      );

      _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
      _betterPlayerController?.setupDataSource(dataSource);

      _betterPlayerController?.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          Duration? position = _betterPlayerController?.videoPlayerController?.value.position;
          if (SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "true") {
            if (position != null && adTimes.contains(position.inSeconds) && !isAdPlaying && !playedAds.contains(position.inSeconds)) {
              playedAds.add(position.inSeconds);
              _playAd(position.inSeconds == 1 ?
              "http://nplflix-content.bizalpha.ca/ads/out/mercedes-1/1080.m3u8" :
              "http://nplflix-content.bizalpha.ca/ads/out/pepsi-1/1080.m3u8");
            }
          }
        }
       });
    } catch (e) {
      debugPrint("Error initializing BetterPlayer: $e");
    }
  }

  void _playAd(String url) {
    _betterPlayerController?.pause();
    setState(() {
      isAdPlaying = true;
    });

    BetterPlayerConfiguration adConfiguration = BetterPlayerConfiguration(
      //aspectRatio: 16 / 9,
      fit: BoxFit.cover,
      autoPlay: true,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableProgressBar: false,
        enablePlayPause: false,
        enableFullscreen: false,
        enableSubtitles: false,
        enableMute: false,
        enableSkips: false,
        enablePlaybackSpeed: false,
      ),
    );

    BetterPlayerDataSource adSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      videoFormat: BetterPlayerVideoFormat.hls,
    );

    _adPlayerController = BetterPlayerController(adConfiguration);
    _adPlayerController?.setupDataSource(adSource);
    _adPlayerController?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        _resumeMainVideo();
      }
    });

    //_setLandscapeOrientation();
  }

  void _resumeMainVideo() {
    _adPlayerController?.dispose();
    setState(() {
      isAdPlaying = false;
    });
    _betterPlayerController?.play();
    //_setLandscapeOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.map["name"] ?? "",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Stack(

            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child:   isAdPlaying && _adPlayerController != null
                      ? BetterPlayer(controller: _adPlayerController!)
                      : _betterPlayerController != null
                      ? BetterPlayer(controller: _betterPlayerController!)
                      : Container(color: Colors.black),

                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

