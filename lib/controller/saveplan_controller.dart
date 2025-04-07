
import 'package:flutter/cupertino.dart';
import 'package:npflix/models/save_plan_model.dart';
import '../enums/posts_enum.dart';
import '../network_module/api_path.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';

class SaveplanController with ChangeNotifier {
  late ApiResponse<SavePlanModel> _savePlan;

  ApiResponse<SavePlanModel> get savePlan => _savePlan;

  SaveplanController() {
    _savePlan = ApiResponse<SavePlanModel>();
  }


  Future<void> savePlanId(var planId,var currency) async {
    var map =  <String, dynamic>{};
    map['planUuid'] = planId.toString();
    map['currency'] = currency.toString();
    map['isMobile'] = true;
    _savePlan = ApiResponse.loading('Fetching content...');
    notifyListeners();
    try {
      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.savePlan), map);
      debugPrint("Save Plan Response: ${apiResponse.toString()}");
      if(apiResponse["isSuccess"] == true){
        String otp = apiResponse["message"];
        _savePlan = ApiResponse.completed(SavePlanModel(message: otp,isFreePlan: apiResponse['data']['isFreePlan']));
      }else{
        _savePlan = ApiResponse.error(apiResponse["message"]);
      }
      // Parse the response to a list of Content objects

      notifyListeners();
    } catch (e) {
      _savePlan = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }


  Future<void> payRentalPlan(var uuid,var rentalEndDate, var rentalDuration, var rentalPrice,var discount,var totalAmount) async {
    var map =  <String, dynamic>{};
    map['uuid'] = uuid.toString();
    map['rentalDuration'] =  rentalDuration;
    map['rentalPrice'] = rentalPrice;
    map['discount'] = discount;
    map['totalAmount'] = totalAmount;
    map['isMobile'] = true;

    _savePlan = ApiResponse.loading('Adding Rental Payment...');
    notifyListeners();
    try {

      // Replace 'APIPath.getContentList' with the appropriate API path for fetching content
      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.payRentalPayment), map);
      debugPrint("Save Plan Response: ${apiResponse.toString()}");
      if(apiResponse["isSuccess"] == true){
        String otp = apiResponse["message"];
        _savePlan = ApiResponse.completed(SavePlanModel(message: otp,isFreePlan: ""));
      }else{
        _savePlan = ApiResponse.error(apiResponse["message"]);
      }
      // Parse the response to a list of Content objects

      notifyListeners();
    } catch (e) {
      _savePlan = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }
}