import 'package:flutter/material.dart';
import 'package:npflix/utils/app_colors.dart';

class TextHeading extends StatelessWidget {
  const TextHeading({
    Key? key,
    required this.text,
    this.softWrap,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
  }) : super(key: key);

  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: fontWeight,
        textBaseline: textBaseline,
        decoration: textDecoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}

class TextRed extends StatelessWidget {
  const TextRed({
    Key? key,
    required this.text,
    this.softWrap,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
    this.fontSize = 14
  }) : super(key: key);

  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.btnColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        textBaseline: textBaseline,
        decoration: textDecoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}


class TextGray extends StatelessWidget {
  const TextGray({
    Key? key,
    required this.text,
    this.softWrap,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
    this.fontSize = 16
  }) : super(key: key);

  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: fontSize,
        textBaseline: textBaseline,
        decoration: textDecoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}

class TextWhite extends StatelessWidget {
  const TextWhite({
    Key? key,
    required this.text,
    this.softWrap,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
    this.fontSize = 14
  }) : super(key: key);


  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        textBaseline: textBaseline,
        decoration: textDecoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: TextOverflow.visible,
      textDirection: textDirection,
    );
  }
}


class PlanTextBold extends StatelessWidget {
  const PlanTextBold({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.softWrap,
    this.textAlign = TextAlign.right,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
  }) : super(key: key);

  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        textBaseline: textBaseline,
        decoration: textDecoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.bold
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}


class PlanText extends StatelessWidget {
  const PlanText({
    Key? key,
    required this.text,
    this.fontSize = 13,
    this.softWrap,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.fontFamily,
    this.fontWeight,
    this.textBaseline,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
  }) : super(key: key);

  final String text;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextBaseline? textBaseline;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          textBaseline: textBaseline,
          decoration: textDecoration,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
      ),
      textScaleFactor: 1,
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}