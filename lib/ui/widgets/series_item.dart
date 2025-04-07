import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';

import '../../utils/helper_methods.dart';

class SeriesItem extends StatelessWidget {
  var image;
  var name;
  var description;
  double height;
  double width;
  SeriesItem({super.key ,required this.image,required this.name,required this.description,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(image,width:  width,height: height,fit: BoxFit.fill,),
        TextWhite(text: name,fontSize: 12,),
        TextGray(text: description,fontSize: 10,)
      ],
    );
  }
}
