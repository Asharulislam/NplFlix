
import 'package:npflix/models/heading_model_v2.dart';

import 'heading_model.dart';

class HomeContent {
  var typeId;
  var type;
  var languageId;
  var orderby;
  final List<HeadingModelV2> headingModel;

  HomeContent({
    required this.typeId,
    required this.type,
    required this.languageId,
    required this.orderby,
    required this.headingModel
  });

  // Factory method to create an instance from a JSON map
  factory HomeContent.fromJson(Map<String, dynamic> json) {
    return HomeContent(
      typeId: json['typeId'],
      type: json['type'],
      languageId : json['languageId'],
        orderby : json['orderby'],
      headingModel: (json['heading'] as List).map((item) => HeadingModelV2.fromJson(item)).toList(),

    );
  }
  //Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'type': type,
      'languageId' : languageId,
      'orderby' : orderby,
      'headingModel' : headingModel
    };
  }

}