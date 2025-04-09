import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

// Import the navigatorKey from main.dart
import 'package:npflix/main.dart' show navigatorKey;
import 'package:npflix/routes/index.dart';

class AppLinksService {
  static final AppLinksService _instance = AppLinksService._internal();
  factory AppLinksService() => _instance;
  AppLinksService._internal();
  
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  Future<void> initDeepLinks() async {
    try {
      // Initial link (cold start)
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        _processDeepLink(appLink);
      }
      
      // Subscribe to link changes (warm start)
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) => _processDeepLink(uri),
        onError: (e) => debugPrint('Deep link error: $e'),
      );
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }
  
  void _processDeepLink(Uri uri) {
    debugPrint('Processing deep link in service file: $uri');
    
    // Extract path and params
    final path = uri.path;
    
    // Handle room path
    if (path == '/room/' || path == '/room') {
      final roomId = uri.queryParameters['id'];
      if (roomId != null) {
        // Create args for your route
        final args = {'roomId': roomId};
        
        // Navigate using the global key and your route name
        // Assuming your route is defined in routes/index.dart as joinRoom
        navigatorKey.currentState?.pushNamed(joinRoom, arguments: args);
      }
    }
    
  }
  
  void dispose() {
    _linkSubscription?.cancel();
  }
}