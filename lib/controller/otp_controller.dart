

import 'package:flutter/cupertino.dart';
import '../enums/posts_enum.dart';
import '../network_module/api_path.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';

class OtpController with ChangeNotifier {
  late ApiResponse<String> _otpVerify;

  ApiResponse<String> get otpVerify => _otpVerify;

  OtpController() {
    _otpVerify = ApiResponse<String>();
  }


  Future<void> otpVerification(var otp) async {
    var map =  <String, String>{};
    map['otpCode'] = otp.toString();
    _otpVerify = ApiResponse.loading('Fetching content...');
    notifyListeners();
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.validateOTP), map);
      debugPrint("OTP Response: ${apiResponse.toString()}");
      if (apiResponse["data"] == null) {
        _otpVerify = ApiResponse.error(apiResponse["message"]);
      } else {
        String otp = apiResponse["data"];
        _otpVerify = ApiResponse.completed(otp);
      }
      notifyListeners();

      // Parse the response to a list of Content objects

    } catch (e) {
      _otpVerify = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }
}