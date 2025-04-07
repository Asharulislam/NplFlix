import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:npflix/utils/helper_methods.dart';

class ButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isInvertedGradient;
  final Color color;

  const ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonWidth = 90,
    this.buttonHeight = 200,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 1,
    this.isInvertedGradient = false,
    this.color = AppColors.btnColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Helper.dynamicWidth(context, buttonWidth),
      child: ElevatedButton(
        onPressed:  () => onPressed(),
        style: ElevatedButton.styleFrom(
          // side: BorderSide(
          //   color: Colors.white, // White border
          //   width: 1.0,         // Border thickness
          // ),
          backgroundColor: color,  // Button background color
        //  foregroundColor: Colors.white, // Button text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1), // Rounded corners (optional)
          ),
        ),


        child: TextWhite(
          text: text,
        ),
      ),


    );
  }
}



class ButtonTextIconWidget extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isInvertedGradient;
  final IconData icon;
  final Color color;

  const ButtonTextIconWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonWidth = 90,
    this.buttonHeight = 200,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 1,
    this.isInvertedGradient = false,
    required this.icon,
    this.color = AppColors.btnColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Helper.dynamicWidth(context, buttonWidth),
      child: ElevatedButton.icon(
        onPressed:  () => onPressed(),
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: Colors.white, // White border
            width: 1.0,         // Border thickness
          ),
          backgroundColor: color,  // Button background color
          foregroundColor: Colors.white, // Button text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1), // Rounded corners (optional)
          ),
        ),

        // style: TextButton.styleFrom(
        //
        //   backgroundColor: color, // Background color
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(1), // Border radius
        //   ),
        //
        // ),
        icon: Icon(
         icon, // Replace with your desired icon
          color: Colors.white,
          size: 22.0,
        ),
        label: TextWhite(text: text,),
      ),


    );
  }
}


