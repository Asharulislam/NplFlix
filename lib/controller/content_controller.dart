import 'package:flutter/material.dart';
import 'package:npflix/models/filter_model.dart';
import 'package:npflix/models/heading_model.dart';
import 'package:npflix/models/home_content.dart';
import 'package:npflix/utils/helper_methods.dart';
import '../enums/posts_enum.dart';
import '../models/content_model.dart';
import '../models/video_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class ContentController with ChangeNotifier {
  late ApiResponse<List<Content>> _contentList;
  late ApiResponse<List<HomeContent>> _homeContent;
  late ApiResponse<Content> _content;
  late ApiResponse<VideoModel> _video;

  ApiResponse<List<Content>> get contentList => _contentList;
  ApiResponse<Content> get content => _content;
  ApiResponse<List<HomeContent>> get homecontent => _homeContent;
  ApiResponse<VideoModel> get video => _video;


  // List<HomeContent> _headingsList = [];
  // List<FilterModel> featureTypeList = [];
  // List<String> moviesTypeList = [];
  // List<String> songsTypeList = [];


  ContentController() {
    _contentList = ApiResponse<List<Content>>();
    _content = ApiResponse<Content>();
    _homeContent = ApiResponse<List<HomeContent>>();
  }

  // Method to fetch content list
  Future<void> fetchContentList() async {
    _contentList = ApiResponse.loading('Fetching content...');
    if(Helper.contentList.isNotEmpty && Helper.homecontentList.isNotEmpty){
      print("Fetching from mobile local data");
      _homeContent = ApiResponse.completed(Helper.homecontentList);
      _contentList = ApiResponse.completed(Helper.contentList);
      notifyListeners();

    } else if(await ConnectivityService.connectivityInstance.isConnected()){
      print("Fetching from internet");
      var map =  <String, String>{};
      map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
      map['UserProfileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
      notifyListeners();
      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.getContentList),params: map);
        if(apiResponse['data'] != null){

          //debugPrint("Content Response List: ${apiResponse.toString()}");
          // Parse the response to a list of Content objects
          List<HomeContent> homeContent = (apiResponse["data"]['homeContents'] as List)
              .map((contentJson) => HomeContent.fromJson(contentJson))
              .toList();
          Helper.homecontentList.clear();
          Helper.homecontentList = homeContent;
          _homeContent = ApiResponse.completed(homeContent);


          // await filterList();
          List<Content> contents = (apiResponse["data"]['contentMaster'] as List)
              .map((contentJson) => Content.fromJson(contentJson))
              .toList();
          Helper.contentList.clear();
          Helper.contentList = contents;
          _contentList = ApiResponse.completed(contents);
          notifyListeners();
        }else{
          _contentList = ApiResponse.error(apiResponse['message']);
          notifyListeners();
        }

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

  Future<void> getContentById(var contentId) async {
    _content = ApiResponse.loading('Fetching content...');
    var map =  <String, String>{};
    map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
    map['UUID'] = contentId.toString();
    map['ProfileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
    map['Resolution'] = "480";
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.getContentById),params: map);
      debugPrint("Content By Id Response: ${apiResponse.toString()}");

      // Parse the response to a list of Content objects
      Content content = Content.fromJson(apiResponse["data"][0]);
      _content = ApiResponse.completed(content);
      debugPrint("Content Like and List: ${content.isLiked}");
      notifyListeners();
    } catch (e) {
      _content = ApiResponse.error("Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }


  Future<void> getVideo(var uuid) async {
    _content = ApiResponse.loading('Fetching content...');
    if(await ConnectivityService.connectivityInstance.isConnected()) {
      var map = <String, String>{};
      map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
      map['UUID'] = uuid.toString();
      map['ProfileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
      map['Resolution'] = "480";
      map['Season_UUID'] = "";
      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.getVideo), params: map);
        debugPrint("Video Response: ${apiResponse.toString()}");
        if(apiResponse["data"] != null){
          VideoModel videoModel = VideoModel.fromJson(apiResponse["data"][0]);
          _video = ApiResponse.completed(videoModel);
          notifyListeners();
        }else{
          _video = ApiResponse.error(apiResponse["message"]);
          notifyListeners();
        }

      } catch (e) {
        _video = ApiResponse.error("Please try again");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _video = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }


  Future<void> getRoomVideo(var uuid,var roomId) async {
    _content = ApiResponse.loading('Fetching content...');
    if(await ConnectivityService.connectivityInstance.isConnected()) {
      var map = <String, String>{};
      map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
      map['UUID'] = uuid.toString();
      map['ProfileId'] = SharedPreferenceManager.sharedInstance.getString("profileId");
      map['Resolution'] = "480";
      map['Season_UUID'] = "";
      map['isRoom'] = "true";
      map['RoomUUID'] = roomId;
      try {
        // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
        var apiResponse = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.getVideo), params: map);
        debugPrint("Video Response: ${apiResponse.toString()}");
        if(apiResponse["data"] != null){
          VideoModel videoModel = VideoModel.fromJson(apiResponse["data"][0]);
          _video = ApiResponse.completed(videoModel);
          notifyListeners();
        }else{
          _video = ApiResponse.error(apiResponse["message"]);
          notifyListeners();
        }

      } catch (e) {
        _video = ApiResponse.error("Please try again");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _video = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }





  // filterList(){
  //   featureTypeList.clear();
  //   moviesTypeList.clear();
  //   songsTypeList.clear();
  //   if(_headingsList.isNotEmpty){
  //     for(int i=0; i<_headingsList.length; i++){
  //       if(_headingsList[i].contentType == "Featured"){
  //        featureTypeList.add(FilterModel(_headingsList[i].heading,_headingsList[i].headingId));
  //       }else if(_headingsList[i].contentType == "Movies"){
  //         moviesTypeList.add(_headingsList[i].heading);
  //       } else if(_headingsList[i].contentType == "Songs"){
  //         songsTypeList.add(_headingsList[i].heading);
  //       }
  //     }
  //   }
  // }
}
