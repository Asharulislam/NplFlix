import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/utils/helper_methods.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../controller/language_change_controller.dart';
import '../../../controller/list_controller.dart';
import '../../../services/connectivity_service.dart';
import '../../../sources/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();

    // Detect screen type before building UI
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     Helper.isTv = MediaQuery.of(context).size.width > 800;
    //   });
    //   playVideo();
    // });
    playVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> playVideo() async {
    _controller = VideoPlayerController.asset("assets/videos/splash_mobile.mp4",)..initialize().then((_) {
      _controller.play();
      _controller.setLooping(false);

      if(SharedPreferenceManager.sharedInstance.getString("language_code") == null){
        LanguageChangeController().changeLanguage(const Locale("en"));
      }
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          checkLogin();
        }
      });

      setState(() {}); // Rebuild to show video when ready
    }).catchError((error) {
      print("Video Player Error: $error");
      checkLogin(); // Fallback if video fails
    });
  }

  getFavList() async{
    var res = await Provider.of<ListController>(context, listen: false).getList();
  }

  Future<void> checkLogin() async {
    final hasToken = SharedPreferenceManager.sharedInstance.hasToken();
    final isConnected = await ConnectivityService.connectivityInstance.isConnected();

    if (hasToken) {
      if(SharedPreferenceManager.sharedInstance.hasKey("userName")){
        getFavList();
        Navigator.of(context).pushNamedAndRemoveUntil(
          bottomNavigation,
          arguments: {"index": isConnected ? 0 : 1},
              (route) => false,
        );
      }else{
        Navigator.of(context).pushNamedAndRemoveUntil(welcomeScreen, (route) => false);
      }

    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(welcomeScreen, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller != null ? _controller.value.isInitialized
          ? SizedBox.expand(
            child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
                    ),
                  ),
          )
          :  Container(
        color: Colors.black,
      ) : Container(
        color: Colors.black,
      ),
    );
  }
}

