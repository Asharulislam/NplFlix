import 'package:flutter/material.dart';
import '../enums/posts_enum.dart';
import '../models/content_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../sources/shared_preferences.dart';

class AddFavoriteController with ChangeNotifier {
  late ApiResponse<Content> _contentList;

  ApiResponse<Content> get contentList => _contentList;

  AddFavoriteController() {
    _contentList = ApiResponse<Content>();
  }

  // Method to search content list
  Future<void> likeContent(var contentId,var uuid,var isLike) async {
    var map =  <String, dynamic>{};
    map['contentId'] = contentId;
    map['uuid'] = uuid.toString();
    map['profileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    map['isLike'] = isLike;
    _contentList = ApiResponse.loading('Fetching content...');
    notifyListeners();
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.likeContent), map);
      debugPrint("Add Favorite Response: ${apiResponse.toString()}");

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
}
