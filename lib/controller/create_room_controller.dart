
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

class CreateRoomController extends ChangeNotifier {
  late ApiResponse<RoomModel> _createRoom;
  late ApiResponse<List<RoomModel>> _getRooms;

  late ApiResponse<String> _cancelRoom;
  late ApiResponse<String> _deleteRoom;
  late ApiResponse<String> _leftRoom;
  late ApiResponse<String> _endRoom;

  ApiResponse<RoomModel> get createRoom => _createRoom;
  ApiResponse<List<RoomModel>> get getRooms => _getRooms;

  ApiResponse<String> get cancelRoom => _cancelRoom;
  ApiResponse<String> get deleteRoom => _deleteRoom;
  ApiResponse<String> get leftRoom => _leftRoom;
  ApiResponse<String> get endRoom => _endRoom;

  CreateRoomController() {

    _createRoom = ApiResponse<RoomModel>();
    _getRooms = ApiResponse<List<RoomModel>>();

    _cancelRoom = ApiResponse<String>();
    _deleteRoom = ApiResponse<String>();
    _leftRoom = ApiResponse<String>();
    _endRoom = ApiResponse<String>();

  }

  getRoomList() async {

    _getRooms = ApiResponse.loading('Fetching plans...');
    notifyListeners();
    if(await ConnectivityService.connectivityInstance.isConnected()) {
      try {
        var apiResponse = await HttpClient.instance.fetchData(
            APIPathHelper.getValue(APIPath.getRoomByUser));
        debugPrint("room list Response: ${apiResponse.toString()}");

        if(apiResponse["data"] != null){
          List<RoomModel> plans = (apiResponse["data"] as List)
              .map((planJson) => RoomModel.fromJson(planJson))
              .toList();
          _getRooms = ApiResponse.completed(plans);
          notifyListeners();
        }else{
          _getRooms = ApiResponse.error(apiResponse["message"]);
          notifyListeners();
        }


      } catch (e) {
        _getRooms = ApiResponse.error("Server Error: Unable to fetch room list.");
        debugPrint("Plan Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _getRooms = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }


  createRoomPost(var roomName,var dateTime, var movieId) async {
    var map =  <String, dynamic>{};
    map["roomName"] = roomName;
    map['startDateTime'] = dateTime;
    map['uuid'] = movieId;
    _createRoom = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.createRoom), map);
      if(apiResponse["data"] != null){
        debugPrint("Room Response $apiResponse");
        RoomModel createRoomModel = RoomModel.fromJson(apiResponse["data"]);
        _createRoom = ApiResponse.completed(createRoomModel);
        notifyListeners();
      }else{
        _createRoom = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _createRoom = ApiResponse.error("Something went wrong please try again");
      debugPrint("Create Room Error $e");
      notifyListeners();
    }
  }

  cancelRoomPost(var roomUUID) async {
    var map =  <String, dynamic>{};
    map["roomUUID"] = roomUUID;
    _cancelRoom = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.cancelRoom), map);
      debugPrint("Cancel Response $apiResponse");
      if(apiResponse['statusCode'] == 200){
        _cancelRoom = ApiResponse.completed(apiResponse['message']);
        notifyListeners();
      }else{
        _cancelRoom = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _cancelRoom = ApiResponse.error("Something went wrong please try again");
      debugPrint("Cancel Room Error $e");
      notifyListeners();
    }
  }

  deleteRoomPost(var roomUUID) async {
    var map =  <String, dynamic>{};
    map["roomUUID"] = roomUUID;
    _deleteRoom = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.deleteRoom), map);
      debugPrint("Delete Response $apiResponse");
      if(apiResponse["statusCode"] == 200){
        print("Delete Room ${apiResponse["message"]}");
        _deleteRoom = ApiResponse.completed(apiResponse["message"].toString());
        notifyListeners();
      }else{
        _deleteRoom = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _deleteRoom = ApiResponse.error("Server Error");
      debugPrint("Cancel Room Error $e");
      notifyListeners();
    }
  }


  leftRoomPost(var roomUUID) async {
    var map =  <String, dynamic>{};
    map["roomUUID"] = roomUUID;
    _leftRoom = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.leftRoom), map);
      if(apiResponse["statusCode"] == 200){
        debugPrint("Left Response $apiResponse");
        _leftRoom = ApiResponse.completed(apiResponse['message']);
        notifyListeners();
      }else{
        _leftRoom = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _leftRoom = ApiResponse.error("Server Error");
      debugPrint("Left Room Error $e");
      notifyListeners();
    }
  }


  endRoomPost(var roomUUID) async {
    var map =  <String, dynamic>{};
    map["roomUUID"] = roomUUID;
    _endRoom = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.endRoom), map);
      if(apiResponse["statusCode"] == 200){
        debugPrint("End Response $apiResponse");
        _endRoom = ApiResponse.completed(apiResponse["message"]);
        notifyListeners();
      }else{
        _endRoom = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }
    } catch (e) {
      _endRoom = ApiResponse.error("Server Error");
      debugPrint("End Room Error $e");
      notifyListeners();
    }
  }




}