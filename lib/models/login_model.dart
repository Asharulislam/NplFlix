
class LoginModel {
  final String token;
  final String? refreshToken;
  final bool isProcessComplete;
  final bool isPaymentDone;
  final String email;
  final int userID;
  final int? planId;
  final int? noOfDaysLeft;
  final bool? isMultiProfile;
  final int? noOfProfiles;
  final bool? isRoom;
  final int? noOfRooms;
  final bool? isDownload;
  final bool? isEmailConfirmed;
  final int? noOfDownload;
  var profileId;
  var profileName;
  var isFreePlan;

  LoginModel({
    required this.token,
    this.refreshToken,
    required this.isProcessComplete,
    required this.isPaymentDone,
    required this.email,
    required this.userID,
    this.planId,
    this.noOfDaysLeft,
    this.isMultiProfile,
    this.noOfProfiles,
    this.isRoom,
    this.noOfRooms,
    this.isDownload,
    this.isEmailConfirmed,
    this.noOfDownload,
    this.profileId,
    this.profileName,
    this.isFreePlan
  });

  // Factory method to create an instance from a JSON map
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      refreshToken: json['refreshToken'],
      isProcessComplete: json['isProcessComplet'],
      isPaymentDone: json['isPaymentDone'],
      email: json['email'],
      userID: json['userID'],
      planId: json['planId'],
      noOfDaysLeft: json['noofDaysLeft'],
      isMultiProfile: json['isMultiProfile'],
      noOfProfiles: json['noofProfiles'],
      isRoom: json['isRoom'],
      noOfRooms: json['noofRooms'],
      isDownload: json['isDownload'],
      noOfDownload: json['noofDownload'],
        profileId: json['profileId'],
        profileName : json['profileName'],
        isEmailConfirmed :json['isEmailConfirmed'],
        isFreePlan : json['isFreePlan']
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'isProcessComplet': isProcessComplete,
      'isPaymentDone': isPaymentDone,
      'email': email,
      'userID': userID,
      'planId': planId,
      'noofDaysLeft': noOfDaysLeft,
      'isMultiProfile': isMultiProfile,
      'noofProfiles': noOfProfiles,
      'isRoom': isRoom,
      'noofRooms': noOfRooms,
      'isDownload': isDownload,
      'noofDownload': noOfDownload,
      "profileId" : profileId,
      "profileName" : profileName,
      "isEmailConfirmed" :isEmailConfirmed,
      "isFreePlan" : isFreePlan
    };
  }
}
