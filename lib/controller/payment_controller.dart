
import 'package:flutter/material.dart';
import 'package:npflix/models/get_payment_model.dart';
import 'package:npflix/models/payment_model.dart';

import '../network_module/api_response.dart';
import '../enums/posts_enum.dart';
import '../network_module/http_client.dart';
import '../network_module/api_path.dart';
import '../sources/shared_preferences.dart';

class PaymentController extends ChangeNotifier {
  late ApiResponse<GetPaymentModel> _getPaymentModel;
  late ApiResponse<PaymentModel> _payPlanPayment;
  late ApiResponse<PaymentModel> _payRentalPayment;

  ApiResponse<GetPaymentModel> get getPaymentModel => _getPaymentModel;
  ApiResponse<PaymentModel> get payPlanPayment => _payPlanPayment;
  ApiResponse<PaymentModel> get payRentalPayment => _payRentalPayment;

  PaymentController() {
    _getPaymentModel = ApiResponse<GetPaymentModel>();
    _payPlanPayment = ApiResponse<PaymentModel>();
    _payRentalPayment = ApiResponse<PaymentModel>();
  }



  // Method to get payment keys
  Future<void> getPaymentKeys() async {

    _getPaymentModel = ApiResponse.loading('Fetching payment method...');
    notifyListeners();
    try {
      var apiResponse = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.getPaymentDetail));
      debugPrint("Payment Details Response: ${apiResponse.toString()}");


      GetPaymentModel contents = GetPaymentModel.fromJson(apiResponse["data"]);
      _getPaymentModel = ApiResponse.completed(contents);
      notifyListeners();
    } catch (e) {
      _getPaymentModel = ApiResponse.error("Unable to get payment details.");
      debugPrint("Payment Details Error: $e");
      notifyListeners();
    }
  }


  Future<void> payPlan(var planUuid,var currency, var customerId, var paymentMethodId) async {
    var map =  <String, String>{};
    map['planUuid'] = planUuid.toString();
    map["currency"] = currency;
    map['customerId'] = customerId;
    map['paymentMethodId'] =  paymentMethodId;
    _payPlanPayment = ApiResponse.loading('Adding Payment...');
    notifyListeners();
    try {

      var apiResponse = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.payPlanPayment), map);
      debugPrint("Payment Response: ${apiResponse.toString()}");

      PaymentModel contents = PaymentModel.fromJson(apiResponse["data"]);
      _payPlanPayment = ApiResponse.completed(contents);
      notifyListeners();
    } catch (e) {
      _payPlanPayment = ApiResponse.error("Server Error: Unable to fetch content.");
      debugPrint("Content Fetch Error: $e");
      notifyListeners();
    }
  }

}