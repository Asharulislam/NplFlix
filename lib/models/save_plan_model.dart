class SavePlanModel {
  var message;
  var isFreePlan;

  SavePlanModel({
    this.message,
    this.isFreePlan
  });

  factory SavePlanModel.fromJson(Map<String, dynamic> json) {
    return SavePlanModel(
      message: json['message'],
      isFreePlan: json['isFreePlan'],
    );
  }



}