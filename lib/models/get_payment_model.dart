
class GetPaymentModel{
  var customerId;
  var paymentMethodId;

  GetPaymentModel({
    this.customerId,
    this.paymentMethodId});



  factory GetPaymentModel.fromJson(Map<String, dynamic> json) {
    return GetPaymentModel(
      customerId: json['customerId'] ,
      paymentMethodId: json['paymentMethodId'],

    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'paymentMethodId': paymentMethodId,

    };
  }
}