
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:npflix/utils/app_colors.dart';

class CustomToast {
  CustomToast._();
  static final CustomToast _singleton = CustomToast._();

  static CustomToast get instance => _singleton;

  FToast fToast = FToast();
  void initialize(BuildContext context) {
    fToast.init(context);
  }

  void showToast(
    context, {
    Color backgroundColor = AppColors.appBarColor,
    required String message,
    Color messageColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Text(message, style: const TextStyle(color: Colors.black)),
      ),
      gravity: gravity,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
