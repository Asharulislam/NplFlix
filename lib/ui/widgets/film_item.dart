import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/helper_methods.dart';
class FilmItem extends StatelessWidget {
  var image;
  var name;
  var description;
  FilmItem({super.key,required this.image,required this.name,required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(image,height: 190,width: Helper.dynamicWidth(context, 100),fit: BoxFit.fill),
        TextWhite(text: name,fontSize: 12,),
        TextGray(text: description,fontSize: 10,)
      ],
    );
  }
}
