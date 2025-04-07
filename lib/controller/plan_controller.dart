
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../enums/posts_enum.dart';
import '../models/plan_model.dart';
import '../network_module/api_response.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../services/connectivity_service.dart';
import '../sources/shared_preferences.dart';

class PlanController with ChangeNotifier {
  late ApiResponse<List<PlanModel>> _planList;

  ApiResponse<List<PlanModel>> get planList => _planList;

  PlanController() {
    _planList = ApiResponse<List<PlanModel>>();
  }

  // Method to fetch the list of plans
  Future<void> fetchPlans() async {

    _planList = ApiResponse.loading('Fetching plans...');
    notifyListeners();
    if(await ConnectivityService.connectivityInstance.isConnected()) {
      try {
        // Replace 'APIPath.getPlans' with the correct API endpoint for fetching plans
        var map =  <String, String>{};
        map['languageId'] = SharedPreferenceManager.sharedInstance.getString("language_code") == "en"  ? "1" : "2";
        var apiResponse = await HttpClient.instance.fetchData(
            APIPathHelper.getValue(APIPath.getPlans));
        debugPrint("Plan Response: ${apiResponse.toString()}");

        // Parse the response to a list of PlanModel objects
        List<PlanModel> plans = (apiResponse["data"] as List)
            .map((planJson) => PlanModel.fromJson(planJson))
            .toList();
        _planList = ApiResponse.completed(plans);
        notifyListeners();
      } catch (e) {
        _planList = ApiResponse.error("Server Error: Unable to fetch plans.");
        debugPrint("Plan Fetch Error: $e");
        notifyListeners();
      }
    }else{
      _planList = ApiResponse.noInternet("Internet not available");
      notifyListeners();
    }
  }
}
