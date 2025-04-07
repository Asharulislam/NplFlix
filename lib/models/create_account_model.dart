class CreateAccountModel {
  var userID;
  var token;

  CreateAccountModel({
    this.userID,
    this.token
  });

  factory CreateAccountModel.fromJson(Map<String, dynamic> json) {
    return CreateAccountModel(
      token: json['token'],
      userID: json['userId'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userID': userID,
    };
  }

}