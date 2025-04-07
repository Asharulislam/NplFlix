// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Validator {
  Validator._();

  static final Validator _singleton = Validator._();

  static Validator get instance => _singleton;

  DateTime dateTime = DateTime.now();

  bool isEmailValidator(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isEmailValid(TextEditingController controller) {
    if (controller.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isPasswordValid(TextEditingController controller) {
    if (controller.text.trim().length >= 8) {
      return true;
    }
    return false;
  }

  bool passwordValidator(String value) {
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*_+,.•\\\/;:∆£¢€¥^~|°=<>©®™✓√π÷×¶?"-]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isFirstNameValid(TextEditingController controller) {
    if (controller.text.trim().length >= 2) {
      return true;
    }
    return false;
  }

  bool isLastNameValid(TextEditingController controller) {
    if (controller.text.trim().length >= 2) {
      return true;
    }
    return false;
  }

  bool userNameValidator(String value) {
    String pattern = r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isUserNameValid(TextEditingController controller) {
    if (controller.text.trim().length >= 2) {
      return true;
    }
    return false;
  }

  //age validator
  bool isAdult(DateTime givenDateFormat) {
    var diff = dateTime.difference(givenDateFormat);
    var age = ((diff.inDays) / 365).round();
    if (age >= 18) {
      return true;
    }
    return false;
  }

  bool specialCharacterValidator(String value) {
    String pattern = r'[!@#$%^&*()/,.?":;\-_=+{}|<>]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool digitsValidator(String value) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
