import 'package:flutter/material.dart';
import '../enums/posts_enum.dart';
import '../models/content_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../sources/shared_preferences.dart';

class WatchTimeController with ChangeNotifier {
  late ApiResponse<Content> _contentList;
  late ApiResponse<bool> _isRemove;

  ApiResponse<Content> get contentList => _contentList;
  ApiResponse<bool> get isRemove => _isRemove;

  WatchTimeController() {
    _contentList = ApiResponse<Content>();
    _isRemove = ApiResponse<bool>();
  }

  // Method to search content list
  Future<void> addWatchTime(var uuid,var contentId,var watchTime) async {
    var map =  <String, dynamic>{};
    map["uuid"] = uuid.toString();
    map['contentId'] = contentId.toString();
    map["watchedTime"] = watchTime;
    map['contentSeasonEpisodeId'] = 0;
    map['profileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    _contentList = ApiResponse.loading('Fetching content...');
    notifyListeners();
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addWatchTime), map);
      debugPrint("Watch Time Added Response: ${apiResponse.toString()}");

      // Parse the response to a list of Content objects
      Content contents = Content.fromJson(apiResponse["data"]);
      _contentList = ApiResponse.completed(contents);
      notifyListeners();
    } catch (e) {
      _contentList = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }

  Future<void> removeWatchTime(var uuid,var contentId) async {
    var map =  <String, dynamic>{};
    map["uuid"] = uuid.toString();
    map['profileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    map['contentId'] = contentId.toString();
    map["watchedTime"] = 0;
    map['contentSeasonEpisodeId'] = 0;
    _isRemove = ApiResponse.loading('Fetching content...');
    notifyListeners();
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.removeContinueWatching), map);
      debugPrint("Remove Watching Time Response: ${apiResponse.toString()}");
      // Parse the response to a list of Content objects
      _isRemove = ApiResponse.completed(true);
      notifyListeners();
    } catch (e) {
      _isRemove = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }
}
