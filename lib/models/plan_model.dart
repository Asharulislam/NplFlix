class PlanModel {
  var planId;
  var title;
  var subTitle;
  var resolution;
  var price;
  var discount;
  var finalPrice;
  var currency;
  var videoAndSoundQuality;
  var supportedDevice;
  var isMultiProfileAllowed;
  var noOfProfilesAllowed;
  var isDownloadAllowed;
  var noOfDownloadsAllowed;
  var planUuid;

  PlanModel({
    this.planId,
    this.title,
    this.subTitle,
    this.resolution,
    this.price,
    this.discount,
    this.finalPrice,
    this.currency,
    this.videoAndSoundQuality,
    this.supportedDevice,
    this.isMultiProfileAllowed,
    this.noOfProfilesAllowed,
    this.isDownloadAllowed,
    this.noOfDownloadsAllowed,
    this.planUuid
  });

  // Factory method to create an instance from a JSON map
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      planId: json['planId'],
      title: json['title'],
      subTitle: json['subTitle'],
      resolution: json['resolution'],
      price: json['price'],
      discount: json['discount'],
      finalPrice: json['finalPrice'],
      currency: json['currency'],
      videoAndSoundQuality: json['videoandSoundQality'],
      supportedDevice: json['suportedDevice'],
      isMultiProfileAllowed: json['isMultiProfileAllowed'],
      noOfProfilesAllowed: json['noofProfilesAllow'],
      isDownloadAllowed: json['isDownloadAllowed'],
      noOfDownloadsAllowed: json['noofDownloadAllow'],
        planUuid : json['planUuid']
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'title': title,
      'subTitle': subTitle,
      'resolution': resolution,
      'price': price,
      'discount': discount,
      'finalPrice': finalPrice,
      'currency': currency,
      'videoandSoundQality': videoAndSoundQuality,
      'suportedDevice': supportedDevice,
      'isMultiProfileAllowed': isMultiProfileAllowed,
      'noofProfilesAllow': noOfProfilesAllowed,
      'isDownloadAllowed': isDownloadAllowed,
      'noofDownloadAllow': noOfDownloadsAllowed,
      'planUuid' : planUuid
    };
  }
}
