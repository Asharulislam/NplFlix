
import 'package:flutter/cupertino.dart';
import 'package:npflix/models/create_account_model.dart';
import 'package:npflix/utils/helper_methods.dart';
import '../enums/posts_enum.dart';
import '../network_module/api_path.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../sources/shared_preferences.dart';

class CreateUserController extends ChangeNotifier {
  late ApiResponse<CreateAccountModel> _createUser;

  ApiResponse<CreateAccountModel> get user => _createUser;

  CreateUserController() {

    _createUser = ApiResponse<CreateAccountModel>();
  }

  createUser(var id, var name) async {

    var map =  <String, dynamic>{};
    map["userId"] = id;
     map['name'] = name;
     map['profilePin'] = "1234";
     map['planId'] = Helper.planId;
    _createUser = ApiResponse.loading('loading... ');
    try {
      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.createProfile), map);

      if(apiResponse["data"] != null){
        debugPrint("Login Response $apiResponse");
        SharedPreferenceManager.sharedInstance.storeString("profileId", apiResponse["data"]["profileID"].toString());
        CreateAccountModel createAccountModel = CreateAccountModel.fromJson(apiResponse["data"]);
        _createUser = ApiResponse.completed(createAccountModel);
        notifyListeners();
      }else{
        _createUser = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }

    } catch (e) {
      _createUser = ApiResponse.error("Server Error");
      debugPrint("Create Account Error $e");

      notifyListeners();
    }
  }


}