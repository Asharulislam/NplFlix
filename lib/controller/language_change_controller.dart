
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sources/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier{
  Locale _appLocale =  SharedPreferenceManager.sharedInstance.hasKey("language_code") ? Locale(SharedPreferenceManager.sharedInstance.getString("language_code")) :const Locale("en");
  Locale get appLocale => _appLocale;

  Future<void> setLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("language_code", "en");
  }

  Future<void> changeLanguage(Locale type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _appLocale = type;
    if(type == const Locale("en")){
      await sharedPreferences.setString("language_code", "en");
    }else{
      await sharedPreferences.setString("language_code", "ne");
    }
    notifyListeners();
  }
}