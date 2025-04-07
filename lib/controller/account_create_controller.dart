 import 'package:flutter/cupertino.dart';
import 'package:npflix/models/create_account_model.dart';
import '../enums/posts_enum.dart';
import '../network_module/api_path.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../sources/shared_preferences.dart';

class AccountCreateController extends ChangeNotifier {
  late ApiResponse<CreateAccountModel> _createAccount;
  late ApiResponse<CreateAccountModel> _createAccountGoogle;

  ApiResponse<CreateAccountModel> get account => _createAccount;
  ApiResponse<CreateAccountModel> get loginGoogle => _createAccountGoogle;

  AccountCreateController() {

    _createAccount = ApiResponse<CreateAccountModel>();
    _createAccountGoogle = ApiResponse<CreateAccountModel>();
  }

  postCreateAccount(var email, var password) async {

    var map =  <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    _createAccount = ApiResponse.loading('loading... ');
    try {

      var  apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.signUp), map);
      debugPrint("Login Response $apiResponse");
      if(apiResponse["data"] == null){
        _createAccount = ApiResponse.error(apiResponse["message"]);
        notifyListeners();
      }else{
        CreateAccountModel createAccountModel = CreateAccountModel.fromJson(apiResponse["data"]);
        SharedPreferenceManager.sharedInstance.storeToken(createAccountModel.token);
        _createAccount = ApiResponse.completed(createAccountModel);
        notifyListeners();
      }

    } catch (e) {
      _createAccount = ApiResponse.error("Unexpected error please try again");
      debugPrint("Create Account Error $e");

      notifyListeners();
    }
  }


}