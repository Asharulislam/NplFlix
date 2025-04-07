import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerWithAds extends StatefulWidget {
  final Map map;

  VideoPlayerWithAds({Key? key, required this.map}) : super(key: key);

  @override
  _VideoPlayerWithAdsState createState() => _VideoPlayerWithAdsState();
}

bool isFirstAd  = true;
double _videoScale = 1.0;
class _VideoPlayerWithAdsState extends State<VideoPlayerWithAds> {
  late BetterPlayerController _playerController;
  bool _adPlayedAt5 = false;
  bool _adPlayedAt30 = false;
  bool _adPlayedAt25 = false;

  bool isNavigate = true;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initializeMainPlayer();
  }



  // Initialize the main video player
  void _initializeMainPlayer() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide system UI

    var key = widget.map["keyPairId"];
    var policy = widget.map["policy"];
    var signature = widget.map["signature"];
    final String cookies =
        'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=${policy}; CloudFront-Signature=${signature}';



    _playerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        fullScreenByDefault: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft
        ],

        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableProgressBar: true,
          enablePlayPause: true,
          enableSkips: true,
          enableFullscreen: false,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.map["url"],
        //"http://nplflix-content.bizalpha.ca/ads/out/pepsi-1/1080.m3u8",
        videoFormat: BetterPlayerVideoFormat.hls,
        drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.token,
          licenseUrl: "https://nplflix-content.bizalpha.ca/",
        ),
        headers: {'Cookie': cookies},
        subtitles: [
          for (int i = 0; i < widget.map["captions"].length; i++)
            BetterPlayerSubtitlesSource(
              type: BetterPlayerSubtitlesSourceType.network,
              urls: [widget.map['captions'][i].captionFilePath],
              name: widget.map['captions'][i].captionFileName,
            ),
        ],
      )
    );

    // Listen for progress to trigger ads
    _playerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        Duration? position = _playerController.videoPlayerController?.value.position;

        if (position != null) {
          if (position.inSeconds >= 1 && !_adPlayedAt5) {
            _adPlayedAt5 = true; // Mark this ad as played
            _playAd("http://nplflix-content.bizalpha.ca/ads/out/pepsi-1/1080.m3u8");
          } else if (position.inSeconds >= 60 && !_adPlayedAt30) {
            _adPlayedAt30 = true; // Mark this ad as played
            _playAd("http://nplflix-content.bizalpha.ca/ads/out/mercedes-1/1080.m3u8");

          }
        }
      }
    });
  }

  // Play the ad in full screen
  void _playAd(var url) async {
    _playerController.pause(); // Pause main video
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenAdPlayer(
          adUrl: url,
          onAdComplete: () {
            _playerController.play(); // Resume main video after ad
          },
        ),
      ),
    ).then((value){
      if(isNavigate){
        isNavigate = false;
        Navigator.pop(context);
      }else{
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
      }

      _playerController.play();
    });
  }

  @override
  void dispose() {
    _playerController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // Show status & nav bars
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          _playerController != null
              ? BetterPlayer(controller: _playerController!)
              : CircularProgressIndicator(),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () async {
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp, // Force portrait before exiting
                    ]);
                    WakelockPlus.disable();
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // Show status & nav bars
                    Navigator.pop(context); // Close the screen
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

// Full-screen ad player
class FullScreenAdPlayer extends StatefulWidget {
  final String adUrl;
  final VoidCallback onAdComplete;

  FullScreenAdPlayer({required this.adUrl, required this.onAdComplete});

  @override
  _FullScreenAdPlayerState createState() => _FullScreenAdPlayerState();
}

class _FullScreenAdPlayerState extends State<FullScreenAdPlayer> {
  late BetterPlayerController _adController;

  @override
  void initState() {
    super.initState();
    _initializeAdPlayer();
  }

  void _initializeAdPlayer() {
    _adController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        fullScreenByDefault: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft
        ],

        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableProgressBar: false,
          enableSkips: false,
          enablePlayPause: false,
          enableFullscreen: false,
        ),
      ),

      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.adUrl,
        videoFormat: BetterPlayerVideoFormat.hls,
      ),
    );

    _adController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
       // widget.onAdComplete();
        if(isFirstAd){
          Navigator.pop(context);
        }
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _adController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide system UI

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Transform.scale(
              scale: _videoScale,
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(controller: _adController)),
            ),
          ),
        ],
      ),
    );
  }
}
