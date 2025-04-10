import 'package:flutter/material.dart';
import 'package:npflix/ui/screens/authentication/create_account.dart';
import 'package:npflix/ui/screens/authentication/login_screen.dart';
import 'package:npflix/ui/screens/bottomnavigation/bottom_navigation.dart';
import 'package:npflix/ui/screens/bottomnavigation/home.dart';
import 'package:npflix/ui/screens/choose_plans/step_one_info.dart';
import 'package:npflix/ui/screens/choose_plans/step_one_info_tv.dart';
import 'package:npflix/ui/screens/choose_plans/step_one_selection.dart';
import 'package:npflix/ui/screens/choose_plans/step_one_selection_tv.dart';
import 'package:npflix/ui/screens/choose_plans/step_three_details.dart';
import 'package:npflix/ui/screens/choose_plans/step_three_details_tv.dart';
import 'package:npflix/ui/screens/choose_plans/step_three_info.dart';
import 'package:npflix/ui/screens/choose_plans/step_three_info_tv.dart';
import 'package:npflix/ui/screens/choose_plans/step_two_details.dart';
import 'package:npflix/ui/screens/choose_plans/step_two_details_tv.dart';
import 'package:npflix/ui/screens/choose_plans/step_two_info.dart';
import 'package:npflix/ui/screens/choose_plans/step_two_info_tv.dart';
import 'package:npflix/ui/screens/download/download_screen.dart';
import 'package:npflix/ui/screens/home/home_screen.dart';
import 'package:npflix/ui/screens/language/language_change.dart';
import 'package:npflix/ui/screens/more/account_settings.dart';
import 'package:npflix/ui/screens/more/edit_profile.dart';
import 'package:npflix/ui/screens/more/inbox.dart';
import 'package:npflix/ui/screens/more/more_screen.dart';
import 'package:npflix/ui/screens/more/privacy_policy.dart';
import 'package:npflix/ui/screens/more/terms_condition.dart';
import 'package:npflix/ui/screens/movie/downloadPlayerScreen.dart';
import 'package:npflix/ui/screens/movie/movie_details.dart';
import 'package:npflix/ui/screens/movie/movie_details_tv.dart';
import 'package:npflix/ui/screens/movie/video_player_ad.dart';
import 'package:npflix/ui/screens/movie/video_player_screen_02.dart';
import 'package:npflix/ui/screens/movie/video_player_screen_tv.dart';
import 'package:npflix/ui/screens/otp/otp_screen.dart';
import 'package:npflix/ui/screens/room/create_room.dart';
import 'package:npflix/ui/screens/room/join_room.dart';
import 'package:npflix/ui/screens/room/room_details.dart';
import 'package:npflix/ui/screens/room/room_list.dart';
import 'package:npflix/ui/screens/room/room_player.dart';
import 'package:npflix/ui/screens/search/search_screen.dart';
import 'package:npflix/ui/screens/user_create/create_user_name.dart';
import 'package:npflix/ui/screens/user_create/create_user_name_tv.dart';
import 'package:npflix/ui/screens/user_create/edit_user.dart';
import 'package:npflix/ui/screens/user_create/select_user.dart';
import 'package:npflix/ui/screens/welcome/splash_screen.dart';
import 'package:npflix/ui/screens/welcome/welcome_screen.dart';
import 'package:npflix/utils/helper_methods.dart';

import '../sources/shared_preferences.dart';
import '../ui/screens/authentication/login_screen_tv.dart';
import '../ui/screens/more/help.dart';
import 'index.dart';

class MyRouter {
  Widget getRouterWithScaleFactor(BuildContext context, Widget screenName,
      {RouteSettings? settings}) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: screenName,
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Debug what's coming in
    debugPrint('Router received route: ${settings.name}');
    debugPrint('Router received arguments: ${settings.arguments}');

    // Extract route name and arguments
    final name = settings.name;
    final args = settings.arguments;

    // Special case: Handle the malformed route that includes ROUTE at the end
    // or any route starting with /room/ or /room
    if (name != null &&
        (name.contains('/room') ||
            name.contains('/room/') ||
            (name.startsWith('/room') && name.contains('ROUTE')))) {
      debugPrint('Handling special room URL case: $name');

      // Try to extract the room ID from the route name
      Map<String, String> roomArgs = {};

      // Check if there's a query parameter in the route name
      if (name.contains('?id=')) {
        // Extract the ID between ?id= and the next & or end of string
        final idStartIndex = name.indexOf('?id=') + 4;
        int idEndIndex = name.indexOf('&', idStartIndex);
        if (idEndIndex == -1) {
          // If no & is found, use the end of the string
          // but first check if there's ROUTE at the end
          if (name.contains('ROUTE')) {
            idEndIndex = name.indexOf('ROUTE', idStartIndex);
          } else {
            idEndIndex = name.length;
          }
        }

        // Extract the ID
        if (idEndIndex > idStartIndex) {
          final roomId = name.substring(idStartIndex, idEndIndex);
          roomArgs = {'roomId': roomId};
          debugPrint('Extracted room ID: $roomId');
        }
      }

      // If arguments were provided directly, use those instead
      if (args != null && args is Map) {
        roomArgs = Map<String, String>.from(args);
      }

      // If we have a room ID, proceed to the JoinRoom screen
      if (roomArgs.isNotEmpty) {
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              JoinRoom(
                map: args,
              )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      }
    }

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const SplashScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case welcomeScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const WelcomeScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context,
              Helper.isTv ? const LoginScreenTv() : const LoginScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case createAccount:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const CreateAccount()),
          settings: RouteSettings(arguments: settings.arguments),
        );

      case stepOneInfo:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context,
              Helper.isTv ? const StepOneInfoTv() : const StepOneInfo()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case stepOneSelection:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? const StepOneSelectionTv()
                  : const StepOneSelection()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case stepTwoInfo:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context,
              Helper.isTv ? const StepTwoInfoTv() : const StepTwoInfo()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case stepTwoDetails:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context,
              Helper.isTv ? const StepTwoDetailsTv() : const StepTwoDetails()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case stepThreeInfo:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? StepThreeInfoTv(map: args)
                  : StepThreeInfo(
                      map: args,
                    )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case stepThreeDetails:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? StepThreeDetailsTv(map: args)
                  : StepThreeDetails(
                      map: args,
                    )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case createUserName:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context,
              Helper.isTv ? const CreateUserNameTv() : const CreateUserName()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case selectUser:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const SelectUser()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case editUser:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const EditUser()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case help:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context, const Help()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case bottomNavigation:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? Home()
                  : BottomNavigation(
                      map: args,
                    )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const HomeScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case searchScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const SearchScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case downloadScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const DownloadScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case moreScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const MoreScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case termsCondition:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const TermsCondition()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case privacyPolicy:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const PrivacyPolicy()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const EditProfile()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case accountSettings:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const AccountSettings()),
          settings: RouteSettings(arguments: settings.arguments),
        );

      case inbox:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, const Inbox()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case movieDetails:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? MovieDetailsTv(map: args)
                  : MovieDetails(
                      map: args,
                    )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case createRoom:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              CreateRoom(
                map: args,
              )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case joinRoom:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              JoinRoom(
                map: args,
              )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case nplflixVideoPlayer:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              Helper.isTv
                  ? VideoPlayerScreenTv(map: args)
                  : SharedPreferenceManager.sharedInstance
                              .getString("isFreePlan") ==
                          "true"
                      ? VideoPlayerAd(map: args)
                      : VideoPlayerScreen02(map: args)),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case downloadVideoPlayer:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context, DownloadPlayerScreen(map: args)),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case languageScreen:
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, LanguageChange()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case otpScreen:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context, OtpScreen()),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case adPlayer:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, VideoPlayerAd(map: args)),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case roomPlayer:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) =>
              getRouterWithScaleFactor(context, RoomPlayer(map: args)),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case roomDetails:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(
              context,
              RoomDetails(
                map: args,
              )),
          settings: RouteSettings(arguments: settings.arguments),
        );
      case roomList:
        return MaterialPageRoute(
          builder: (context) => getRouterWithScaleFactor(context, RoomList()),
          settings: RouteSettings(arguments: settings.arguments),
        );

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('No route defined for $name'),
        ),
      );
    });
  }
}
