
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';


class DownloadPlayerScreen extends StatefulWidget {
  Map map;
  DownloadPlayerScreen({Key? key, required this.map}) : super(key: key);

  @override
  State<DownloadPlayerScreen> createState() => _VideoPlayerScreenState();
}

BetterPlayerController? _betterPlayerController;
class _VideoPlayerScreenState extends State<DownloadPlayerScreen> {


  @override
  void dispose() {
    // TODO: implement dispose
    _betterPlayerController?.pause();
    WakelockPlus.disable();
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState()   {
    // TODO: implement initState
    super.initState();
    WakelockPlus.enable();
    setPlayer().then((_) {
      if (mounted) {
        setState(() {

        }); // Rebuild UI after controller is set
      }
    });
  }

  setPlayer() async {
    String localServerUrl = await startLocalServer();
    String videoUrl = "$localServerUrl${widget.map["url"]}";
    print("Video Url ${videoUrl}");
    _betterPlayerController =  BetterPlayerController(
        const BetterPlayerConfiguration(
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp
          ],
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          autoDispose: true,
          looping: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableProgressBar: true,
            enablePlayPause: true,
            enableFullscreen: true,
            progressBarPlayedColor: Colors.red,
            progressBarHandleColor: Colors.white,
            progressBarBackgroundColor: Colors.grey,
            enableSkips: true,

          ),

        )
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      videoFormat: BetterPlayerVideoFormat.hls,
    );
    _betterPlayerController!.setupDataSource(dataSource);
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        child: Center(
          child: _betterPlayerController == null
              ? const CircularProgressIndicator() :  BetterPlayer(
              controller: _betterPlayerController!
          ),
        ),
      ),
    );
  }



  Future<String> startLocalServer() async {
    // If a server is already running, close it first
    if (Helper.server != null) {
      await Helper.server!.close(force: true);
      Helper.server = null;
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appPath = appDocDir.path;

    var handler = createStaticHandler(appPath, defaultDocument: 'index.html');

    Helper.server = await io.serve(handler, 'localhost', 8080);
    return 'http://${Helper.server?.address.host}:${Helper.server?.port}/';
  }

}


