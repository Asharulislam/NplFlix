

import 'package:flutter/cupertino.dart';
import 'package:npflix/models/create_account_model.dart';
import 'package:npflix/utils/helper_methods.dart';
import '../enums/posts_enum.dart';
import '../models/room_model.dart';
import '../network_module/api_path.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class ManageRoomParticipantsController extends ChangeNotifier {
  late ApiResponse<String> _approveParticipate;
  late ApiResponse<String> _blockParticipate;
  late ApiResponse<RoomModel> _getParticipate;


  ApiResponse<String> get approveParticipate => _approveParticipate;
  ApiResponse<String> get blockParticipate => _blockParticipate;
  ApiResponse<RoomModel> get getParticipate => _getParticipate;


  ManageRoomParticipantsController() {

    _approveParticipate = ApiResponse<String>();
    _blockParticipate = ApiResponse<String>();
    _getParticipate =  ApiResponse<RoomModel>();
  }

  approveParticipant(var userUUID,var roomUUID) async {
    var map =  <String, dynamic>{};
    map["userUUID"] = userUUID;
    map['roomUUID'] = roomUUID;
    _approveParticipate = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.approveParticipate), map);
      if(apiResponse['statusCode'] == 200){
        debugPrint("Approve Participate ${apiResponse["message"]}");
        _approveParticipate = ApiResponse.completed(apiResponse["message"]);
        notifyListeners();
      }else{
        _approveParticipate = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _approveParticipate = ApiResponse.error("Server Error");
      debugPrint("Approve Participate Error $e");
      notifyListeners();
    }
  }

  blockParticipant(var userUUID,var roomUUID,var reason) async {
    var map =  <String, dynamic>{};
    map["userUUID"] = userUUID;
    map['roomUUID'] = roomUUID;
    map['reason'] = reason;
    _blockParticipate = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.blockParticipate), map);
      if(apiResponse['statusCode'] == 200){
        debugPrint("Block Participate $apiResponse");
        _blockParticipate = ApiResponse.completed(apiResponse["message"]);
        notifyListeners();
      }else{
        _blockParticipate = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _blockParticipate = ApiResponse.error("Server Error");
      debugPrint("Block Participate Error $e");
      notifyListeners();
    }
  }

  Future<void> getParticipateList(var roomUUID) async {
    _getParticipate = ApiResponse.loading('Fetching content...');

    if(await ConnectivityService.connectivityInstance.isConnected()) {
      var map = <String, String>{};
      map['roomUUID'] = roomUUID;
      notifyListeners();
      try {
        var apiResponse = await HttpClient.instance.fetchData(
            APIPathHelper.getValue(APIPath.getRoom), params: map);
        debugPrint("Participant Response: ${apiResponse.toString()}");

        if (apiResponse["data"] == null) {
          _getParticipate = ApiResponse.error(apiResponse["message"]);
        } else {
          // Parse the response to a list of Content objects
           RoomModel roomModel  = RoomModel.fromJson(apiResponse["data"]);
          _getParticipate = ApiResponse.completed(roomModel);
        }

        notifyListeners();
      } catch (e) {
        _getParticipate = ApiResponse.error("Unable to fetch content.");
        debugPrint("Content Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _getParticipate = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }

}