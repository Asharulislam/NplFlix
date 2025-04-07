class PaymentModel{
  var planUuid;
  var currency;
  var customerId;
  var paymentMethodId;

  PaymentModel({
    this.planUuid,
    this.currency,
    this.customerId,
    this.paymentMethodId
  });



  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        planUuid: json['planUuid'] ,
        currency: json['currency'],
        customerId: json['customerId'],
        paymentMethodId: json['paymentMethodId']

    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'planUuid': planUuid,
      'currency': currency,
      'customerId' : customerId,
      'paymentMethodId' : paymentMethodId

    };
  }
}