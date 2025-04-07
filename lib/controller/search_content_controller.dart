import 'package:flutter/material.dart';
import '../enums/posts_enum.dart';
import '../models/content_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class SearchContentController with ChangeNotifier {
  late ApiResponse<List<Content>> _contentList;

  ApiResponse<List<Content>> get contentList => _contentList;

  SearchContentController() {
    _contentList = ApiResponse<List<Content>>();
  }

  // Method to search content list
  Future<void> searchContentList(var searchText) async {
    _contentList = ApiResponse.loading('Fetching content...');

    if(await ConnectivityService.connectivityInstance.isConnected()) {
      var map = <String, String>{};
      map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
      map['searchText'] = searchText;
      notifyListeners();
      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.fetchData(
            APIPathHelper.getValue(APIPath.searchContent), params: map);
        debugPrint("Content Response: ${apiResponse.toString()}");

        // Parse the response to a list of Content objects
        List<Content> contents = (apiResponse["data"] as List)
            .map((contentJson) => Content.fromJson(contentJson))
            .toList();
        _contentList = ApiResponse.completed(contents);
        notifyListeners();
      } catch (e) {
        _contentList = ApiResponse.error("Unable to fetch content.");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    } else{
      _contentList = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }
}
