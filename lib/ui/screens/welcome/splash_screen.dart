// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:npflix/routes/index.dart';
// import 'package:npflix/services/applinkDeeplinks_service.dart';
// import 'package:npflix/utils/helper_methods.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// import '../../../controller/language_change_controller.dart';
// import '../../../controller/list_controller.dart';
// import '../../../services/connectivity_service.dart';
// import '../../../sources/shared_preferences.dart';


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late VideoPlayerController _controller;


//   @override
//   void initState() {
//     super.initState();

//     // Detect screen type before building UI
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   setState(() {
//     //     Helper.isTv = MediaQuery.of(context).size.width > 800;
//     //   });
//     //   playVideo();
//     // });
//      // Initialize deep links after the widget is built
//     // Initialize deep links but don't process them yet
   
//     playVideo();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> playVideo() async {
//     _controller = VideoPlayerController.asset("assets/videos/splash_mobile.mp4",)..initialize().then((_) {
//       _controller.play();
//       _controller.setLooping(false);

//       if(SharedPreferenceManager.sharedInstance.getString("language_code") == null){
//         LanguageChangeController().changeLanguage(const Locale("en"));
//       }
//       _controller.addListener(() {
//         if (_controller.value.position >= _controller.value.duration) {
//           checkLogin();
//         }
//       });

//       setState(() {}); // Rebuild to show video when ready
//     }).catchError((error) {
//       print("Video Player Error: $error");
//       checkLogin(); // Fallback if video fails
//     });
//   }

//   getFavList() async{
//     var res = await Provider.of<ListController>(context, listen: false).getList();
//   }

//   Future<void> checkLogin() async {
//     final hasToken = SharedPreferenceManager.sharedInstance.hasToken();
//     final isConnected = await ConnectivityService.connectivityInstance.isConnected();

//     if (hasToken) {
//       if(SharedPreferenceManager.sharedInstance.hasKey("userName")){
//         getFavList();
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           bottomNavigation,
//           arguments: {"index": isConnected ? 0 : 1},
//               (route) => false,
//         );
//       }else{
//         Navigator.of(context).pushNamedAndRemoveUntil(welcomeScreen, (route) => false);
//       }

//     } else {
//       Navigator.of(context).pushNamedAndRemoveUntil(welcomeScreen, (route) => false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _controller != null ? _controller.value.isInitialized
//           ? SizedBox.expand(
//             child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//             width: _controller.value.size.width,
//             height: _controller.value.size.height,
//             child: VideoPlayer(_controller),
//                     ),
//                   ),
//           )
//           :  Container(
//         color: Colors.black,
//       ) : Container(
//         color: Colors.black,
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/services/applinkDeeplinks_service.dart';
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
  Uri? _initialDeepLink;
  bool _isDeepLink = false;
  
  @override
  void initState() {
    super.initState();
    
    // Check if we launched from a deep link
    checkForDeepLink();
    
    // Play video regardless, but we'll skip to the end if it's a deep link
    playVideo();
  }

    Future<void> checkForDeepLink() async {
    try {
      final appLinks = AppLinks();
      _initialDeepLink = await appLinks.getInitialLink();
      _isDeepLink = _initialDeepLink != null;
      
      if (_isDeepLink) {
        // If we have a deep link, make the video playback faster
        // to minimize waiting time but still show branding
        _controller?.setPlaybackSpeed(3.0);
      }
    } catch (e) {
      debugPrint("Error checking for deep links: $e");
    }
  }
  
  Future<void> playVideo() async {
    _controller = VideoPlayerController.asset("assets/videos/splash_mobile.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        
        if(SharedPreferenceManager.sharedInstance.getString("language_code") == null){
          LanguageChangeController().changeLanguage(const Locale("en"));
        }
        
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            // When video ends, either process deep link or do normal login flow
            if (_isDeepLink && _initialDeepLink != null) {
              processDeepLink(_initialDeepLink!);
            } else {
              checkLogin();
            }
          }
        });
        
        setState(() {});
      }).catchError((error) {
        print("Video Player Error: $error");
        
        // Handle failure the same way - either deep link or normal flow
        if (_isDeepLink && _initialDeepLink != null) {
          processDeepLink(_initialDeepLink!);
        } else {
          checkLogin();
        }
      });
  }
  
  void processDeepLink(Uri uri) {
    final path = uri.path;
    
    if (path == '/room/' || path == '/room') {
      final roomId = uri.queryParameters['id'];
      if (roomId != null) {
        final args = {'roomId': roomId};
        
        // Check login status using your existing method
        final hasToken = SharedPreferenceManager.sharedInstance.hasToken();
        
        if (hasToken) {
          if(SharedPreferenceManager.sharedInstance.hasKey("userName")){
            // User is logged in with username, go to room
            Navigator.of(context).pushReplacementNamed(
              joinRoom,
              arguments: args
            );
          } else {
            // User has token but no username, go to welcome
            Navigator.of(context).pushReplacementNamed(welcomeScreen);
          }
        } else {
          // User is not logged in, go to welcome
          Navigator.of(context).pushReplacementNamed(welcomeScreen);
          
          // Show login required message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to join the room'))
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> playVideo() async {
  //   _controller = VideoPlayerController.asset("assets/videos/splash_mobile.mp4",)..initialize().then((_) {
  //     _controller.play();
  //     _controller.setLooping(false);

  //     if(SharedPreferenceManager.sharedInstance.getString("language_code") == null){
  //       LanguageChangeController().changeLanguage(const Locale("en"));
  //     }
  //     _controller.addListener(() {
  //       if (_controller.value.position >= _controller.value.duration) {
  //         checkLogin();
  //       }
  //     });

  //     setState(() {}); // Rebuild to show video when ready
  //   }).catchError((error) {
  //     print("Video Player Error: $error");
  //     checkLogin(); // Fallback if video fails
  //   });
  // }

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
    // Your existing build method remains the same
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: _controller != null ? _controller.value.isInitialized
  //         ? SizedBox.expand(
  //           child: FittedBox(
  //                   fit: BoxFit.cover,
  //                   child: SizedBox(
  //           width: _controller.value.size.width,
  //           height: _controller.value.size.height,
  //           child: VideoPlayer(_controller),
  //                   ),
  //                 ),
  //         )
  //         :  Container(
  //       color: Colors.black,
  //     ) : Container(
  //       color: Colors.black,
  //     ),
  //   );
  // }
}