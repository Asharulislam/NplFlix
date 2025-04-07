

import 'package:flutter/material.dart';
import 'package:npflix/enums/posts_enum.dart';
import 'package:npflix/network_module/api_path.dart';
import '../models/login_model.dart';
import '../network_module/api_response.dart';
import '../repositories/login_repo.dart';
import '../enums/index.dart';
import '../network_module/http_client.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class LoginController with ChangeNotifier {
  //late LoginRepository _loginRepository;
  //late GoogleLoginRepository _googleLoginRepository;

  late ApiResponse<LoginModel> _login;
  late ApiResponse<LoginModel> _loginGoogle;

  ApiResponse<LoginModel> get login => _login;
  ApiResponse<LoginModel> get loginGoogle => _loginGoogle;

  LoginController() {
  //  _loginRepository = LoginRepository();
  //  _googleLoginRepository = GoogleLoginRepository();
    _login = ApiResponse<LoginModel>();
    _loginGoogle = ApiResponse<LoginModel>();
  }

  postLogin(var email, var password) async {
    _login = ApiResponse.loading('loading... ');

    var map =  <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    if(await ConnectivityService.connectivityInstance.isConnected()) {
      try {
        var apiResponse = await HttpClient.instance.postData(
            APIPathHelper.getValue(APIPath.login), map);
        debugPrint("Login Response $apiResponse");
        if (apiResponse["data"] == null) {
          _login = ApiResponse.error(apiResponse["message"]);
        } else {
          LoginModel loginModel = LoginModel.fromJson(apiResponse["data"]);

          _login = ApiResponse.completed(loginModel);
          notifyListeners();
        }
      } catch (e) {
        _login = ApiResponse.error("Server Error");
        debugPrint("Login Error $e");
        notifyListeners();
      }
    }else{
      _login = ApiResponse.noInternet("Please check your internet connection");
      notifyListeners();
    }
  }

  // postGoogleDataDetails(payload) async {
  //   _loginGoogle = ApiResponse.loading('loading... ');
  //   try {
  //     LoginModel login = await _googleLoginRepository.postLogin(payload);
  //     _loginGoogle = ApiResponse.completed(login);
  //     notifyListeners();
  //   } catch (e) {
  //     _loginGoogle = ApiResponse.error("Server Error");
  //
  //     notifyListeners();
  //   }
  // }
}
