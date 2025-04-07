import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/helper_methods.dart';

class SongItem extends StatelessWidget {
  var image;
  var title;
  var singer;
  var year;
  var details;
  var duration;
  SongItem({super.key,required this.image,required this.title,required this.singer,required this.year, required this.details,required this.duration});


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //  Image.asset(image,height: 90,width: 160,),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            image,
            height: 90,
            width: 160, fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: Helper.dynamicWidth(context, 2),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWhite(text: title,textAlign: TextAlign.start,fontSize: 16,),
              SizedBox(
                height: Helper.dynamicWidth(context, 1),
              ),
              PlanText(text: singer.toString()),
              SizedBox(
                height: Helper.dynamicWidth(context, 1),
              ),
              PlanText(text: "$year - ${Helper.formatDuration(duration)}"),
              SizedBox(
                height: Helper.dynamicWidth(context, 1),
              ),
              TextGray(text: details,textAlign: TextAlign.start,fontSize: 12,)
            ],
          ),
        )
      ],
    );
  }
}
