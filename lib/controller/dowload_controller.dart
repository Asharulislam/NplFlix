
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:npflix/models/content_model.dart';
import 'package:npflix/models/download_progress_model.dart';
import '../network_module/api_response.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DowloadController extends ChangeNotifier {

  late ApiResponse<List<String>> _listVideos;
  late ApiResponse<List<Content>> _listDownload;


  ApiResponse<List<Content>> get listDownload => _listDownload;
  ApiResponse<List<String>> get listVideos => _listVideos;

  Map<String, StreamController<DownloadProgressModel>> downloadControllers = {};

  StreamController<DownloadProgressModel> getController(String fileName) {
    if (!downloadControllers.containsKey(fileName)) {
      downloadControllers[fileName] = StreamController<DownloadProgressModel>.broadcast();
    }
    return downloadControllers[fileName]!;
  }



  DowloadController() {
    _listDownload = ApiResponse<List<Content>>();
    _listVideos = ApiResponse<List<String>>();
  }



  Future<bool> fileExists(String fileName) async {
    StreamController<DownloadProgressModel> controller = getController(fileName);

    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appPath = appDocDir.path;
      String filePath = '$appPath/$fileName';
      if(File(filePath).existsSync()){
        controller.sink.add(DownloadProgressModel(status: "Downloaded",videoFile: fileName));
      }
      return File(filePath).existsSync();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }



  Future<void> saveVideoAndMetadata(
      String videoUrl, String imageUrl, Map<String, dynamic> metadata, String fileName, String cookies) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appPath = appDocDir.path;

      // Define file paths
      String m3u8FilePath = '$appPath/$fileName';
      String imageFilePath = '$appPath/${fileName.split('.').first}_image.jpg';
      String metadataFilePath = '$appPath/${fileName.split('.').first}_metadata.json';

      // Check if video file already exists
      if (await File(m3u8FilePath).exists()) {
        print('File already exists: $m3u8FilePath');
        return;
      }

      Dio dio = Dio();

      // Set headers with cookies
      Options options = Options(
        headers: {
          'Cookie': cookies, // Include cookies for authentication
          'User-Agent': 'YourApp/1.0',
        },
      );

      // Download image
      await dio.download(imageUrl, imageFilePath, options: options);
      print("Image saved: $imageFilePath");
      StreamController<DownloadProgressModel> controller = getController(fileName);


      // Fetch M3U8 file content
      Response response = await dio.get(videoUrl, options: options);
      String m3u8Content = response.data.toString();

      // Extract base URL
      Uri videoUri = Uri.parse(videoUrl);
      String baseUrl = videoUri.origin + videoUri.path.substring(0, videoUri.path.lastIndexOf("/") + 1);

      List<String> lines = m3u8Content.split("\n");


      // Check if it's a master playlist (contains another .m3u8 file)
      String? referencedM3U8;
      for (String line in lines) {
        if (line.trim().endsWith(".m3u8")) {
          referencedM3U8 = line.trim();
          break;
        }
      }

      if (referencedM3U8 != null) {
        // Download the actual M3U8 file with segment URLs
        String newM3U8Url = baseUrl + referencedM3U8;
        print("Master Playlist detected. Fetching actual M3U8 file: $newM3U8Url");

        Response newM3U8Response = await dio.get(newM3U8Url, options: options);
        m3u8Content = newM3U8Response.data.toString();
        lines = m3u8Content.split("\n");

        print("Lines ${lines}");

        // Update base URL in case it has changed
        Uri newM3U8Uri = Uri.parse(newM3U8Url);
        baseUrl = newM3U8Uri.origin + newM3U8Uri.path.substring(0, newM3U8Uri.path.lastIndexOf("/") + 1);
      }

      // Process and download segments
      List<String> newM3U8Content = [];
      int downloadedSegments = 0;
      int totalSegments = lines.where((line) => line.endsWith(".ts")).length;

      for (String line in lines) {
        if (line.trim().endsWith(".ts")) {
          String segmentUrl = baseUrl + line.trim();
          String segmentPath = '$appPath/${line.split('/').last}';

          await dio.download(segmentUrl, segmentPath, options: options, onReceiveProgress: (received, total) {
            if (total != -1) {
              double progress = ((downloadedSegments + received / total) / totalSegments) * 100;
              print("${progress.toStringAsFixed(0)}%");
              controller.sink.add(DownloadProgressModel(status: "${progress.toStringAsFixed(0)}%",videoFile: fileName));
            }
          });

          newM3U8Content.add(segmentPath.split('/').last);
          downloadedSegments++;
        } else {
          newM3U8Content.add(line);
        }
      }

      // Save modified .m3u8 file
      File m3u8File = File(m3u8FilePath);
      await m3u8File.writeAsString(newM3U8Content.join("\n"));
      print("M3U8 file saved: $m3u8FilePath");


      // Save metadata JSON
      File metadataFile = File(metadataFilePath);
      await metadataFile.writeAsString(jsonEncode(metadata));
      print('Metadata saved: $metadataFilePath');

      controller.sink.add(DownloadProgressModel(status: "Downloaded",videoFile: fileName));

    } catch (e) {
      print("Error downloading M3U8, image, or metadata: $e");
    }
  }

  Future<void> getDownloadedVideos() async {
    _listDownload = ApiResponse.loading('loading... ');
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appPath = appDocDir.path;

      // List all files in the directory
      List<FileSystemEntity> files = Directory(appPath).listSync();

      // Create a map to pair videos with metadata
      Map<String, String> metadataMap = {};

      // Collect all metadata files
      for (var file in files) {
        if (file is File && file.path.endsWith('_metadata.json')) {
          String baseName = file.path.split('/').last.replaceAll('_metadata.json', '');
          metadataMap[baseName] = file.path;
        }
      }

      List<Content> list = [];
      List<String> listVideo = [];

      for (var file in files) {
        if (file is File && file.path.endsWith('.m3u8')) {
          String baseName = file.path.split('/').last.replaceAll('.m3u8', '');
          listVideo.add(file.path);

          // Find the corresponding metadata file
          if (metadataMap.containsKey(baseName)) {
            String metadataContent = await File(metadataMap[baseName]!).readAsString();
            list.add(Content.fromJson(parseMetadata(metadataContent)));
          } else {
            print('No metadata found for: ${file.path}');
          }
        }
      }

      print('Total matched videos: ${listVideo.length}');
      print('Total matched metadata: ${list.length}');

      _listVideos = ApiResponse.completed(listVideo);
      _listDownload = ApiResponse.completed(list);
      notifyListeners();
    } catch (e) {
      _listDownload = ApiResponse.error(e.toString());
      notifyListeners();
      print('Error fetching downloaded videos: $e');
    }
  }


  Map<String, dynamic> parseMetadata(String metadataContent) {
    try {
      return jsonDecode(metadataContent); // Correct way to return parsed JSON
    } catch (e) {
      print('Error parsing metadata: $e');
      return {}; // Return an empty map on error
    }
  }


  // New Function: Delete Video and Metadata
  Future<void> deleteVideoAndMetadata(String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appPath = appDocDir.path;

      String videoFilePath = '$appPath/$fileName';
      String imageFilePath = '$appPath/${fileName.split('.').first}_image.jpg';
      String metadataFilePath = '$appPath/${fileName.split('.').first}_metadata.json';

      // Delete video file
      File videoFile = File(videoFilePath);
      if (videoFile.existsSync()) {
        await videoFile.delete();
        print('Deleted video: $videoFilePath');
      }

      // Delete image file
      File imageFile = File(imageFilePath);
      if (imageFile.existsSync()) {
        await imageFile.delete();
        print('Deleted image: $imageFilePath');
      }

      // Delete metadata file
      File metadataFile = File(metadataFilePath);
      if (metadataFile.existsSync()) {
        await metadataFile.delete();
        print('Deleted metadata: $metadataFilePath');
      }

      // Refresh the list
      await getDownloadedVideos();
      print('Deleted files successfully.');
    } catch (e) {
      print('Error deleting video or metadata: $e');
    }
  }


}