import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
// Import the navigatorKey from main.dart
import 'package:npflix/main.dart' show myNavKey, navigatorKey;
import 'package:npflix/routes/index.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:npflix/ui/screens/authentication/login_screen.dart';
import 'package:npflix/ui/screens/room/join_room.dart';

class AppLinksService {
  static final AppLinksService _instance = AppLinksService._internal();
  factory AppLinksService() => _instance;
  AppLinksService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    try {
      // Skip initial link handling as that's now done in the splash screen
      // Only subscribe to new links that come in while the app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          debugPrint('Received deep link from stream: $uri');
          _processDeepLink(uri);
        },
        onError: (e) => debugPrint('Deep link error: $e'),
      );
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }

  Future<bool> _isUserLoggedIn() async {
    return SharedPreferenceManager.sharedInstance.hasToken();
  }

  void _processDeepLink(Uri uri) async {
    debugPrint('Processing deep link: $uri');

    // Check if the user is logged in
    final isLoggedIn = await _isUserLoggedIn();

    // Extract path and params
    final path = uri.path;
    debugPrint('Deep link path: $path');
    debugPrint('Deep link query parameters: ${uri.queryParameters}');

    // Handle room path
    if (path == '/room/' || path == '/room') {
      final roomId = uri.queryParameters['id'];
      if (roomId != null) {
        final args = {'roomId': roomId};
        debugPrint('Navigating to JoinRoom with roomId: $roomId');

        // if (isLoggedIn) {
        //   // In AppLinksService._processDeepLink:
        //   if (myNavKey.currentState != null &&
        //       myNavKey.currentContext != null) {
        //     // Use pushNamedAndRemoveUntil to navigate while clearing the stack
        //     myNavKey.currentState!.pushNamedAndRemoveUntil(
        //         joinRoom, (route) => true, // Clear all previous routes
        //         arguments: args);
        //   }
        // } 
        // else {
        //   // Navigate to login
        //   myNavKey.currentState
        //       ?.pushNamedAndRemoveUntil(loginScreen, (route) => true);

        //   if (myNavKey.currentContext != null) {
        //     ScaffoldMessenger.of(myNavKey.currentContext!).showSnackBar(
        //       const SnackBar(content: Text('Please log in to join the room')),
        //     );
        //   }
        // }
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
