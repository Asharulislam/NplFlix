import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:npflix/ui/screens/room/join_room.dart';

// Import the navigatorKey from main.dart
import 'package:npflix/main.dart' show navigatorKey;

class AppLinksService {
  static final AppLinksService _instance = AppLinksService._internal();
  factory AppLinksService() => _instance;
  AppLinksService._internal();
  
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  // Flag to track if we've already handled a deep link during this session
  bool _hasHandledInitialDeepLink = false;
  
  Future<void> initDeepLinks() async {
    try {
      // Initial link (cold start)
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null && !_hasHandledInitialDeepLink) {
        debugPrint('Received initial deep link: $appLink');
        _processDeepLink(appLink);
        _hasHandledInitialDeepLink = true;
      }
      
      // Subscribe to link changes (warm start)
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
  
  // Reset this when the user actively opens the app without a deep link
  void resetDeepLinkFlag() {
    _hasHandledInitialDeepLink = false;
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
        
        if (isLoggedIn) {
          // Use direct navigation to avoid routing issues
          if (navigatorKey.currentContext != null) {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => JoinRoom(map: args),
              ),
            );
          } else {
            debugPrint('Error: Current context is null, cannot navigate');
          }
        } else {
          // User is not logged in, navigate to login
          navigatorKey.currentState?.pushNamed(loginScreen);
          
          if (navigatorKey.currentContext != null) {
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              const SnackBar(content: Text('Please log in to join the room')),
            );
          }
        }
      }
    }
  }
  
  void dispose() {
    _linkSubscription?.cancel();
  }
}