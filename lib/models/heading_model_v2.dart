import 'package:npflix/models/heading_content_model.dart';

class HeadingModelV2 {
  final int headingId;
  final String heading;
  final int orderby;
  final  List<HeadingContentModel> headingContentModel;

  HeadingModelV2({
    required this.headingId,
    required this.heading,
    required this.orderby,
    required this.headingContentModel
  });

  // Factory method to create an instance from a JSON map
  factory HeadingModelV2.fromJson(Map<String, dynamic> json) {
    return HeadingModelV2(
      headingId: json['headingId'],
      heading: json['heading'],
        orderby: json['orderby'],
        headingContentModel :(json['content'] as List).map((item) => HeadingContentModel.fromJson(item)).toList(),
    );
  }
  //Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'headingId': headingId,
      'heading': heading,
      'orderby' : orderby,
      'headingContentModel' : headingContentModel
    };
  }
}