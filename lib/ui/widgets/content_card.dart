import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';

import '../../utils/app_colors.dart';
import '../../utils/helper_methods.dart';

class ContentCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double progress; // Progress percentage (0.0 to 1.0)
  final VoidCallback onRemove;
  final VoidCallback onDetail;
  final VoidCallback onPlay;

  const ContentCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.progress,
    required this.onRemove,
    required this.onDetail,
    required this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Thumbnail Image
        Container(
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

        // Play Icon (Shown on hover/tap)
        Positioned.fill(
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

        // Remove from Watchlist Icon (Top Right)
        Positioned(
          top: 2,
          right: 2,
          left: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onDetail,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0,bottom: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    padding: EdgeInsets.all(1),
                    child: Image.asset("assets/images/png/i.png",color: Colors.white,height: 16,)
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    padding: EdgeInsets.all(1),
                    child: Icon(Icons.remove, color: Colors.white,size: 16,),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Progress Bar (Bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.black.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}
