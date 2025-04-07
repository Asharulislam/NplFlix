import 'package:flutter/material.dart';
import 'package:npflix/network_module/api_base.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';

import '../../sources/shared_preferences.dart';

class MyListItem extends StatelessWidget {
  var id;
  var title;
  var year;
  var details;
  var duration;
  final VoidCallback onRemove;
  final VoidCallback onDetail;
  final VoidCallback onPlay;
  final bool isFree;
  MyListItem({super.key,required this.id,
    required this.title,
    required this.year,
    required this.details,
    required this.duration,
    required this.onRemove,
    required this.onDetail,
    required this.onPlay,
    required this.isFree
  });


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
                child: Image.network(
                  "${APIBase.baseImageUrl+id}/img-thumb-sm-h.jpg",
                  height: 90,
                  width: 160,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // The image has finished loading.
                    }
                    return Container(
                      height: 90,
                      width: 160,
                      color: AppColors.imageBackground, // Placeholder background color.
                      child: Center(
                        child: TextWhite(text: title)
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      height: 90,
                      width: 160,
                        color: AppColors.imageBackground, // Background color for error state.
                      child: Center(
                        child: TextWhite(text: title),
                      )
                    );
                  },
                ),
              ),
              Visibility(
                visible: isFree  || SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "false",
                child: GestureDetector(
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
              ),
              Visibility(
                visible: !isFree && SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "true",
                child: Positioned(
                  top: 4,
                  right: 4,
                  left: 2,
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white,width: 2)

                        ),
                        padding: EdgeInsets.all(1),
                        child: const Icon(Icons.diamond_outlined, color: Colors.white,size: 20,),
                      ),
                    ],
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
          child: Row(
            children: [
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
              ),
              Column(

                children: [
                  GestureDetector(
                    onTap: onDetail,
                    child: Icon(Icons.info_outlined, color: Colors.white,size: 28,),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black38,
                        shape: BoxShape.circle,
                          border: Border.all(color: Colors.white,width: 2)
                      ),
                      padding: EdgeInsets.all(1),
                      child: Icon(Icons.remove, color: Colors.white,size: 18,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
