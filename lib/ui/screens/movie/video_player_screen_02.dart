import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:http/http.dart' as http;
import 'package:npflix/models/video_model.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../controller/watch_time_controller.dart';

class VideoPlayerScreen02 extends StatefulWidget {
  final Map map;
  VideoPlayerScreen02({super.key,required this.map});

  @override
  State<VideoPlayerScreen02> createState() => _VideoPlayerScreen02State();
}

class _VideoPlayerScreen02State extends State<VideoPlayerScreen02> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isScreenLocked = false;
  bool _isMaterialControlles = false;
  Timer? _materialControllesTimer;
  double _brightness = 0.5;
  double _volume = 0.5;


  Timer? _volumeSliderTimer;
  Timer? _brightnessSliderTimer;

  // Variables
  List<Caption> _captions = [];
  Caption? _selectedCaption;
  List<Subtitle> _subtitles = [];
  Subtitle? _currentSubtitle;
  bool _subtitlesEnabled = true;
  late WatchTimeController _watchTimeController;
  bool _isFitToScreen = false; // Add this new variable
  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _initializeVolume();
    _initializeBrightness();
    setupCaptions(); // Load subtitles

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky); // Hide system UI
    // Keep screen on during video playback
    WakelockPlus.enable();
  }

  Future<void> _initializeVolume() async {
    // Get current system volume
    final volume = await FlutterVolumeController.getVolume() ?? 0.5;
    setState(() {
      _volume = volume;
    });
  }

  Future<void> _initializeBrightness() async {
    // Get current screen brightness
    final brightness = await ScreenBrightness().system;
    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> _initializePlayer() async {
    _watchTimeController = Provider.of<WatchTimeController>(context, listen: false);
    var key = widget.map["keyPairId"];
    var policy = widget.map["policy"];
    var signature = widget.map["signature"];
    final String cookies =
        'CloudFront-Key-Pair-Id=$key; CloudFront-Policy=${policy}; CloudFront-Signature=${signature}';


    // Replace with your video URL or asset
    _videoPlayerController = VideoPlayerController.networkUrl(
      formatHint: VideoFormat.hls,
      httpHeaders: {'Cookie': cookies},
      Uri.parse(widget.map["url"]),
    );

    await _videoPlayerController.initialize();

    // Add listener for subtitle sync
    _videoPlayerController.addListener(_subtitleSync);

    // Add this position listener to update the UI when video position changes
    _videoPlayerController.addListener(_updatePosition);

    _videoPlayerController.seekTo(Duration(seconds: widget.map["watchedTime"]));

    _createChewieController();

    setState(() {});
  }

  void _updatePosition() {

    if (mounted && _videoPlayerController.value.isPlaying) {
      setState(() {
        // Just triggering a rebuild so the time display updates
      });
    }
  }

  // Called in initState or whenever receiving the captions
  void setupCaptions() {
    // Normally you would get this from your API
    List<Map<String, dynamic>> captionsJson = [];
    for (int i = 0; i < widget.map["captions"].length; i++) {
      captionsJson.add({
        "isTrailler": widget.map['captions'][i].isTrailler,
        "languageId": widget.map['captions'][i].languageId,
        "captionFileName":widget.map['captions'][i].captionFileName,
        "captionFilePath":widget.map['captions'][i].captionFilePath,
      });
    }

    _captions = captionsJson.map((json) => Caption.fromJson(json)).toList();

    // Default to first caption (usually English)
    if (_captions.isNotEmpty) {
      _selectedCaption = _captions.first;
      _loadSubtitleFile(_selectedCaption!.captionFilePath);
    }
  }

  // Load VTT file content
  Future<void> _loadSubtitleFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _parseVttSubtitles(response.body);
      } else {
        debugPrint('Failed to load subtitles: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading subtitles: $e');
    }
  }

// Parse VTT format
  void _parseVttSubtitles(String vttContent) {
    final List<Subtitle> subtitles = [];
    final lines = vttContent.split('\n');
    int i = 0;

    // Skip WebVTT header
    while (i < lines.length && !lines[i].contains('-->')) {
      i++;
    }

    // Parse cues
    while (i < lines.length) {
      if (lines[i].contains('-->')) {
        final timeLine = lines[i].trim();
        final timeComponents = timeLine.split(' --> ');

        if (timeComponents.length == 2) {
          final startTime = _parseVttTime(timeComponents[0]);
          final endTime = _parseVttTime(timeComponents[1]);

          i++;
          String text = '';
          while (i < lines.length && lines[i].trim().isNotEmpty) {
            if (text.isNotEmpty) text += '\n';
            text += lines[i].trim();
            i++;
          }

          if (text.isNotEmpty) {
            subtitles.add(Subtitle(
              start: startTime,
              end: endTime,
              text: text,
            ));
          }
        }
      }
      i++;
    }

    setState(() {
      _subtitles = subtitles;
    });
  }

// Parse VTT time format (00:00:00.000)
  Duration _parseVttTime(String timeString) {
    final cleaned = timeString.trim();
    final parts = cleaned.split(':');

    int hours = 0;
    int minutes = 0;
    double seconds = 0;

    if (parts.length == 3) {
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
      seconds = double.parse(parts[2]);
    } else if (parts.length == 2) {
      minutes = int.parse(parts[0]);
      seconds = double.parse(parts[1]);
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds.floor(),
      milliseconds: ((seconds - seconds.floor()) * 1000).round(),
    );
  }

// Sync subtitles with video - add this to video player listener
  void _subtitleSync() {
    if (!_subtitlesEnabled || _subtitles.isEmpty) {
      _currentSubtitle = null;
      return;
    }

    final position = _videoPlayerController.value.position;

    Subtitle? subtitle;
    for (var sub in _subtitles) {
      if (position >= sub.start && position <= sub.end) {
        subtitle = sub;
        break;
      }
    }

    if (subtitle != _currentSubtitle) {
      setState(() {
        _currentSubtitle = subtitle;
      });
    }
  }

// Add this method to switch between subtitle languages
  void switchSubtitleLanguage(Caption newCaption) {
    setState(() {
      _selectedCaption = newCaption;
      _subtitles = []; // Clear current subtitles
      _currentSubtitle = null; // Reset current subtitle
    });

    // Load the new subtitle file
    _loadSubtitleFile(newCaption.captionFilePath);
  }

  void _showSubtitleMenu(BuildContext context) {
    // Add "None" option at the beginning of the list
    final List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem<String>(
        value: 'none',
        child: Text('None'),
      ),
      const PopupMenuDivider(),
    ];

    // Add all caption languages
    for (var caption in _captions) {
      menuItems.add(
        PopupMenuItem<String>(
          value: caption.captionFilePath,
          child: Text(caption.captionFileName),
        ),
      );
    }

    // Show the popup menu
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
          100, 80, 0, 100), // Adjust position as needed
      items: menuItems,
    ).then((value) {
      if (value == null) return;

      if (value == 'none') {
        // Disable subtitles
        setState(() {
          _subtitlesEnabled = false;
          _currentSubtitle = null;
        });
      } else {
        // Find the selected caption
        for (var caption in _captions) {
          if (caption.captionFilePath == value) {
            setState(() {
              _subtitlesEnabled = true;
              _selectedCaption = caption;
              _subtitles = [];
              _currentSubtitle = null;
            });

            // Load the new subtitle file
            _loadSubtitleFile(caption.captionFilePath);
            break;
          }
        }
      }
    });
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showOptions: false, // Disable default options dialog
      customControls: const MaterialControls(), // Use modified controls
      // Hide default controls so we can show our own
      showControlsOnInitialize: false,
    );

    _resetSliderAndButtonsVisiblity();
  }

  void _resetSliderAndButtonsVisiblity() {
    //video progress slider and play pause buttons also the brightness and volume ICONS
    setState(() {
      _isMaterialControlles = true;
    });
    _materialControllesTimer?.cancel();
    _materialControllesTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _isMaterialControlles = false;
      });
    });
  }

  Future<void> changeVolume(double value) async {
    await FlutterVolumeController.setVolume(value);
    setState(() {
      _volume = value;
    });
  }

  Future<void> changeBrightness(double value) async {
    await ScreenBrightness().setApplicationScreenBrightness(value);
    setState(() {
      _brightness = value;
    });
  }

  void toggleScreenLock() {
    setState(() {
      _isScreenLocked = !_isScreenLocked;
    });
  }

  // Add this method to toggle between aspect ratio and fill screen
  void toggleFitToScreen() {
    setState(() {
      _isFitToScreen = !_isFitToScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _videoPlayerController.value.isInitialized
          ? Stack(
        children: [
          // Custom video container with zoom that affects only the video
          Center(
            child: _buildZoomableVideoOnly(),
          ),

          // Screen locked indicator
          if (_isScreenLocked)
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: toggleScreenLock,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          //(hide when locked)
          if (!_isScreenLocked && _chewieController != null)
            _buildScreenSubtitlesAndScreenLockOverlay(),

          //(hide when locked)
          if (!_isScreenLocked && _chewieController != null)
            _buildScreenBrightnessAndVolumeOverlay(),
          //(hide when locked)
          if (!_isScreenLocked && _chewieController != null)
            _buildScreenVideoProgressOverlay(),

          // Subtitles overlay
          if (_subtitlesEnabled) _buildSubtitlesOverlay(),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _skipForward() {
    final newPosition =
        _videoPlayerController.value.position + const Duration(seconds: 10);
    // Make sure we don't go past the end of the video
    if (newPosition < _videoPlayerController.value.duration) {
      _videoPlayerController.seekTo(newPosition);
    } else {
      _videoPlayerController.seekTo(_videoPlayerController.value.duration);
    }
  }

  void _skipBackward() {
    final newPosition =
        _videoPlayerController.value.position - const Duration(seconds: 10);
    // Make sure we don't go before the start of the video
    if (newPosition > Duration.zero) {
      _videoPlayerController.seekTo(newPosition);
    } else {
      _videoPlayerController.seekTo(Duration.zero);
    }
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Backward 10s button
        IconButton(
          icon: const Icon(
            Icons.replay_10,
            color: Colors.white,
            size: 36,
          ),
          onPressed: _skipBackward,
        ),

        const SizedBox(width: 16),

        // Play/Pause button
        IconButton(
          icon: Icon(
            _videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.white,
            size: 48,
          ),
          onPressed: () {
            setState(() {
              _videoPlayerController.value.isPlaying
                  ? _videoPlayerController.pause()
                  : _videoPlayerController.play();
            });
          },
        ),

        const SizedBox(width: 16),

        // Forward 10s button
        IconButton(
          icon: const Icon(
            Icons.forward_10,
            color: Colors.white,
            size: 36,
          ),
          onPressed: _skipForward,
        ),
      ],
    );
  }

// Then modify your _buildZoomableVideoOnly() method:
  Widget _buildZoomableVideoOnly() {
    final videoAspectRatio = _videoPlayerController.value.aspectRatio;

    return GestureDetector(
      onTap: () {
        if (!_isScreenLocked) {
          _resetSliderAndButtonsVisiblity();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video container with proper aspect ratio or fit to screen
          Center(
            child: _isFitToScreen
                ? SizedBox.expand(
                    // This will expand to fill the available space
                    child: FittedBox(
                      fit: BoxFit
                          .cover, // This makes the video cover the entire space
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width /
                            videoAspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                  )
                : AspectRatio(
                    // Original aspect ratio
                    aspectRatio: videoAspectRatio,
                    child: ClipRect(
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
          ),

          // Invisible controls layer
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: 0.0,
                child: Chewie(controller: _chewieController!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitlesOverlay() {
    // Don't display anything if subtitles are disabled or no current subtitle
    if (!_subtitlesEnabled || _currentSubtitle == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _currentSubtitle!.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildScreenBrightnessAndVolumeOverlay() {
    return Visibility(
      visible: _isMaterialControlles,
      child: Positioned(
        top: 80,
        left: 0,
        right: 0,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Icon(Icons.brightness_6,
                        color: Colors.white, size: 25),
                    RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: const SliderThemeData(
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white70,
                          inactiveTrackColor: Colors.white30,
                          trackHeight: 2.0,
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                        ),
                        child: Slider(
                          value: _brightness,
                          onChanged: changeBrightness,
                        ),
                      ),
                    ),
                  ],
                ),

                // Volume control
                Column(
                  children: [
                    Icon(
                      _volume == 0
                          ? Icons.volume_off
                          : _volume < 0.5
                          ? Icons.volume_down
                          : Icons.volume_up,
                      color: Colors.white,
                      size: 25,
                    ),
                    // const SizedBox(width: 8),
                    RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: const SliderThemeData(
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white70,
                          inactiveTrackColor: Colors.white30,
                          trackHeight: 2.0,
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                        ),
                        child: Slider(
                          value: _volume,
                          onChanged: changeVolume,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenVideoProgressOverlay() {
    return Visibility(
      visible: _isMaterialControlles,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // Progress indicator
              VideoProgressIndicator(
                _videoPlayerController,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.white54,
                  backgroundColor: Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),

              // Play/Pause button + time
              Row(
                children: [
                  // Current position / Total duration
                  Text(
                    '${_formatDuration(_videoPlayerController.value.position)} / ${_formatDuration(_videoPlayerController.value.duration)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  _buildPlaybackControls(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildScreenSubtitlesAndScreenLockOverlay() {
    return Visibility(
      visible: _isMaterialControlles,
      child: Positioned(
        top: 20,
        left: 0,
        right: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () async {
                // await SystemChrome.setPreferredOrientations([
                //   DeviceOrientation.portraitUp, // Force portrait before exiting
                //   DeviceOrientation.portraitDown,
                // ]);
                dispose();
                Navigator.pop(context); // Close the screen
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Add the fit to screen button
                IconButton(
                  icon: Icon(
                    _isFitToScreen ? Icons.fit_screen : Icons.aspect_ratio,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    toggleFitToScreen();
                  },
                ),
                IconButton(
                  icon: Icon(
                    _subtitlesEnabled ? Icons.subtitles : Icons.subtitles_off,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    _showSubtitleMenu(context);
                  },
                ),
                // Lock screen
                IconButton(
                  icon: const Icon(Icons.lock_outline, color: Colors.white),
                  onPressed: toggleScreenLock,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format duration as mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_subtitleSync);
    _chewieController?.dispose();
    _volumeSliderTimer?.cancel();
    _brightnessSliderTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Force portrait before exiting
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // Show status & nav bars
    WakelockPlus.disable();

    super.dispose();

  }
}

// Simple caption model
class Caption {
  final String captionFileName;
  final String captionFilePath;

  Caption({
    required this.captionFileName,
    required this.captionFilePath,
  });

  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(
      captionFileName: json['captionFileName'] ?? '',
      captionFilePath: json['captionFilePath'] ?? '',
    );
  }
}

// Subtitle model for parsed VTT subtitles
class Subtitle {
  final Duration start;
  final Duration end;
  final String text;

  Subtitle({
    required this.start,
    required this.end,
    required this.text,
  });
}