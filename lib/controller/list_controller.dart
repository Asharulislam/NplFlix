
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:npflix/models/add_list_model.dart';
import 'package:npflix/utils/helper_methods.dart';
import '../enums/posts_enum.dart';
import '../models/content_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class ListController with ChangeNotifier {
  late ApiResponse<List<Content>> _contentList;
  late ApiResponse<AddListModel> _addContentList;

  ApiResponse<List<Content>> get contentList => _contentList;
  ApiResponse<AddListModel> get addContentList => _addContentList;
  StreamController<bool> isInListController = StreamController<bool>.broadcast();

  ListController() {
    _contentList = ApiResponse<List<Content>>();
    _addContentList  = ApiResponse<AddListModel>();
  }

  // Method to search content list
  Future<void> getList() async {
    _contentList = ApiResponse.loading('Fetching content...');

    if(await ConnectivityService.connectivityInstance.isConnected()) {
      var map = <String, String>{};
      map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
      map['UserProfileId'] =
          SharedPreferenceManager.sharedInstance.getString("profileId");
      notifyListeners();
      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.fetchData(
            APIPathHelper.getValue(APIPath.getList), params: map);
        debugPrint("Content Response: ${apiResponse.toString()}");

        if (apiResponse["data"] == null) {
          _contentList = ApiResponse.error(apiResponse["message"]);
        } else {
          // Parse the response to a list of Content objects
          List<Content> contents = (apiResponse["data"] as List)
              .map((contentJson) => Content.fromJson(contentJson))
              .toList();

          _contentList = ApiResponse.completed(contents);
          setList();
        }

        notifyListeners();
      } catch (e) {
        _contentList = ApiResponse.error("Unable to fetch content.");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _contentList = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }
  setList(){
    for(int i=0; i<contentList.data.length; i++){
      if(!Helper.isFavList.contains(contentList.data[i].contentId.toString())){
        Helper.isFavList.add(contentList.data[i].contentId.toString());
      }
    }
  }

  checkList(var contentId){
    print("Check List");
    if(Helper.isFavList.contains(contentId.toString())){
      print("Check List true");
      isInListController.sink.add(true);
    }else{
      print("Check false");
      isInListController.sink.add(false);
    }
  }


  Future<void> addList(var contentId, var uuid) async {
    var map =  <String, dynamic>{};
    map['contentId'] = contentId.toString();
    map['profileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    map['uuid'] = uuid;
    map['isMyList'] = true;
    _addContentList = ApiResponse.loading('Fetching content...');
    notifyListeners();
    if(!Helper.isFavList.contains(contentId.toString())){
      try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addMyList),map);
        debugPrint("Content  Add: ${apiResponse.toString()}");
        if(apiResponse["data"] == null){
          _addContentList = ApiResponse.error(apiResponse["message"]);
        }
        else{
          AddListModel contents = AddListModel.fromJson(apiResponse["data"]);
          if(!Helper.isFavList.contains(contentId.toString())){
            Helper.isFavList.add(contentId.toString());
          }
          checkList(contentId);
          _addContentList = ApiResponse.completed(contents);
        }
      // Parse the response to a list of Content objects
        notifyListeners();
      } catch (e) {
        _addContentList = ApiResponse.error("Server Error: Unable to fetch content.");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    }
  }


  Future<void> removeList(var contentId, var uuid) async {
    var map =  <String, dynamic>{};
    map['contentId'] = contentId.toString();
    map['profileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    map['uuid'] = uuid;
    map['isMyList'] = false;
    _addContentList = ApiResponse.loading('Fetching content...');
    notifyListeners();

      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addMyList),map);
        debugPrint("Content  List removed: ${apiResponse.toString()}");
        if(apiResponse["data"] == null){
          _addContentList = ApiResponse.error(apiResponse["message"]);
        }
        else{
          AddListModel contents = AddListModel.fromJson(apiResponse["data"]);
          Helper.isFavList.remove(contentId.toString());
          _addContentList = ApiResponse.completed(contents);
        }
        // Parse the response to a list of Content objects
        notifyListeners();
      } catch (e) {
        _addContentList = ApiResponse.error("Server Error: Unable to fetch content.");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }

  }

}
