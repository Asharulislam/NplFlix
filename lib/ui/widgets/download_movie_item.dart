import 'dart:io';

import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/helper_methods.dart';

class DownloadMovieItem extends StatelessWidget {
  var image;
  var title;
  var year;
  var details;
  var duration;
  final VoidCallback onPlay;
  DownloadMovieItem({super.key,required this.image,required this.title,required this.year, required this.details,required this.duration,required this.onPlay});


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //  Image.asset(image,height: 90,width: 160,),
        SizedBox(
          height: 90,
          width: 160,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  File(image),
                  height: 90,
                  width: 160, fit: BoxFit.fill,
                ),
              ),
              GestureDetector(
                onTap: onPlay,
                child: Positioned.fill(
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white,width: 2)
                      ),// Hover effect
                      child: GestureDetector(
                          onTap: onPlay,
                          child: Icon(Icons.play_arrow, size: 32, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
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
              PlanText(text: year.toString()),
              SizedBox(
                height: Helper.dynamicWidth(context, 1),
              ),
              PlanText(text: Helper.formatDuration(duration)),
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
