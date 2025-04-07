class HeadingModel {
  final int contentTypeId;
  final String contentType;
  final int headingId;
  final String heading;
  final int languageId;
  final int orderby;

  HeadingModel({
    required this.contentTypeId,
    required this.contentType,
    required this.headingId,
    required this.heading,
    required this.languageId,
    required this.orderby,
  });

  // Factory method to create an instance from a JSON map
  factory HeadingModel.fromJson(Map<String, dynamic> json) {
    return HeadingModel(
      contentTypeId: json['contentTypeId'],
      contentType: json['contentType'],
      headingId: json['headingId'],
      heading: json['heading'],
      languageId: json['languageId'],
      orderby: json['orderby'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'contentTypeId': contentTypeId,
      'contentType': contentType,
      'headingId': headingId,
      'heading': heading,
      'languageId': languageId,
      'orderby': orderby,
    };
  }
}
