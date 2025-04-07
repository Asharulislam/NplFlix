import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';

import '../../sources/shared_preferences.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper_methods.dart';

class ContentItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isFree;


  const ContentItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.isFree
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Thumbnail Image
        SizedBox(
          width: Helper.dynamicWidth(context, 27),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.imageBackground,
                  child: Center(child: TextWhite(text: title)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.imageBackground,
                  child: Center(child: TextWhite(text: title)),
                );
              },
            ),
          ),
        ),


        // Remove from Watchlist Icon (Top Right)
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

        // Progress Bar (Bottom)

      ],
    );
  }
}
