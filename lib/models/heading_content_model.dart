class HeadingContentModel {
  final int contentId;
  final String uuid;

  HeadingContentModel({
    required this.contentId,
    required this.uuid,

  });

  // Factory method to create an instance from a JSON map
  factory HeadingContentModel.fromJson(Map<String, dynamic> json) {
    return HeadingContentModel(
      contentId: json['contentId'],
      uuid: json['uuid'],
    );
  }

  //Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'uuid': uuid,
    };
  }

}