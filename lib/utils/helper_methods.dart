import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npflix/models/content_model.dart';
import 'package:npflix/models/home_content.dart';
import 'package:npflix/ui/widgets/button.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../sources/shared_preferences.dart';

class Helper {
  static List<Content> contentList = [];
  static List<HomeContent> homecontentList = [];
  static var platform = "Android";
  static var apiVersion = "v2";
  static var appVersion = "1.0";
  static bool isDownloadRedirect = false;
  static List<String> isFavList = [];
  static var planId = -1;
  static var isTv = false;
  static HttpServer? server; // Store server instance
  static var email = "";
  static var password = "";
  static var movieRoomTime = 0;
  static var langugaeId = 1;




  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        // Android device ID
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // This is the device's unique ID.
      } else if (Platform.isIOS) {
        // iOS device ID
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor.toString(); // Unique ID for the device.
      }
    } catch (e) {
      print("Error retrieving device ID: $e");
    }
    return "Unknown";
  }


  static dynamicFont(BuildContext context, double fontSize) {
    final mediaQuery = MediaQuery.of(context).size;

    return ((mediaQuery.height + mediaQuery.width) / 100) * fontSize;
  }

  static dynamicWidth(BuildContext context, double width) {
    final mediaQuery = MediaQuery.of(context).size;

    return (mediaQuery.width / 100) * width;
  }

  static dynamicHeight(BuildContext context, double height) {
    final mediaQuery = MediaQuery.of(context).size;

    return (mediaQuery.height / 100) * height;
  }

  // join multiple errors
  static String getValuesFromMap(Map<String, dynamic> result) {
    List<String> resultConcator = [];
    String output;

    for (var value in result.values) {
      resultConcator.add(value[0]);
    }
    resultConcator.join();

    output = resultConcator.join('\n');
    if (kDebugMode) {
      print(output);
    }
    return output;
  }

  static String convertToISO8601(String date, TimeOfDay time) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(date);

    // Create a new DateTime with the provided TimeOfDay
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
      0,
      0,
      0,
    );

    // Convert to UTC and format as ISO 8601
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateTime.toUtc());
  }

  //error handler for single/multiple errors
  static List errorHandler(String val) {
    List<String> results = [];
    List<String> resultConcator = [];
    String output;

    val.toString().substring(0, 2);
    results.add(val.toString().substring(0, 3));

    Map<String, dynamic> errors =
        json.decode(val.toString().substring(3, val.toString().length));

    if (errors.values.length > 1) {
      for (var value in errors['errors'].values) {
        resultConcator.add(value[0]);
      }
      resultConcator.join();

      output = resultConcator.join('\n');

      results.add(output);
    } else {
      results.add(errors['message']);
    }

    return results;
  }

  static String getAge(DateTime dateTime) {
    DateTime _dateTime = DateTime.now();
    var diff = _dateTime.difference(dateTime);
    var age = (diff.inDays) ~/ 366;
    return age.toString();
  }

  // give time like 3 minutes/seconds ago etc


  static String getFormattedDate(Timestamp timestamp) {
    DateTime now = DateTime.now().toLocal();
    DateTime messageTime = timestamp.toDate().toLocal(); // Convert Firestore Timestamp to DateTime

    int inDays = now.difference(messageTime).inDays;
    int inHours = now.difference(messageTime).inHours;
    int inMinutes = now.difference(messageTime).inMinutes;
    int inSeconds = now.difference(messageTime).inSeconds;

    if (now.year == messageTime.year) {
      if (now.month == messageTime.month) {
        if (now.day == messageTime.day) {
          if (inHours > 0) {
            return "${inHours}h ago";
          } else if (inMinutes > 0) {
            return "${inMinutes}m ago";
          } else {
            return "${inSeconds}s  ago";
          }
        } else if (inDays == 1) {
          return "Yes";
        } else {
          return "${messageTime.day}/${messageTime.month}/${messageTime.year}";
        }
      }
      return "${messageTime.day}/${messageTime.month}/${messageTime.year}";
    }
    return "${messageTime.day}/${messageTime.month}/${messageTime.year}";
  }


  static String concateTwoStrings(String fName, String lName) {
    String fullName = fName + " " + lName;
    return fullName;
  }

  static int getYearFromDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return parsedDate.year; // Extracts the year from the parsed DateTime
    } catch (e) {
      throw FormatException("Invalid date format: $date");
    }
  }

  static bool isEmail(String em) {
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(em);
    debugPrint("Email Valid $emailValid");

    return emailValid;
  }
  static String formatDuration(int minutes) {
    final int hours = minutes ~/ 60; // Integer division to get hours
    final int remainingMinutes = minutes % 60; // Remainder to get minutes
    if(hours>0){
      return '${hours}h ${remainingMinutes}m';
    }else{
      return '${remainingMinutes}m';
    }

  }

  static bool isPlay(var isFreeContent, var payload){
    if(SharedPreferenceManager.sharedInstance.getString("isFreePlan") == "false"){
     return true;
    }else if(isFreeContent){
      return true;
    }else if(payload != null){
      return true;
    }else{
      return false;
    }

  }

  static double calculateRent(double amount, double discount, int days){
    var cal = 0.0;
    if(days == 1){
     cal = amount;
    }else{
      cal = (amount-discount) * days;
    }
    return cal;
  }

  static deleteDialog(var context,var name,  {required Null Function() onPress}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          //  title: Text(heading),
          content: SizedBox(

            height: 150,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextHeading(text: AppLocalizations.of(context)!.delete_video),
                SizedBox(
                  height: 20,
                ),
                TextWhite(text: "${AppLocalizations.of(context)!.are_you_sure_you_want_to_delete} ${name}",textAlign: TextAlign.center,),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(onPressed: onPress, text: AppLocalizations.of(context)!.delete,buttonWidth: 30,),
                    SizedBox(
                      width: 10,
                    ),
                    ButtonWidget(onPressed: (){
                      Navigator.pop(context);
                    }, text: AppLocalizations.of(context)!.cancel,buttonWidth: 30,
                    color: Colors.black,),

                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }

  static deleteRoom(var context,var name,  {required Null Function() onPress}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          //  title: Text(heading),
          content: SizedBox(

            height: 150,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextHeading(text: "Delete Room"),
                SizedBox(
                  height: 20,
                ),
                TextWhite(text: "${AppLocalizations.of(context)!.are_you_sure_you_want_to_delete} ${name}",textAlign: TextAlign.center,),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(onPressed: onPress, text: AppLocalizations.of(context)!.delete,buttonWidth: 30,),
                    SizedBox(
                      width: 10,
                    ),
                    ButtonWidget(onPressed: (){
                      Navigator.pop(context);
                    }, text: AppLocalizations.of(context)!.cancel,buttonWidth: 30,
                      color: Colors.black,),

                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }


  static removeWatchDialog(var context,var name,  {required Null Function() onPress}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          //  title: Text(heading),
          content: SizedBox(

            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("${AppLocalizations.of(context)!.are_you_sure_you_want_to_remove} ${name}",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.black),),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(onPressed: onPress, text: AppLocalizations.of(context)!.delete,buttonWidth: 30,),
                    SizedBox(
                      width: 10,
                    ),
                    ButtonWidget(onPressed: (){
                      Navigator.pop(context);
                    }, text: AppLocalizations.of(context)!.cancel,buttonWidth: 30,
                      color: Colors.black,),

                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }

  static deleteRoomDialog(var context,var name,  {required Null Function() onPress}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          //  title: Text(heading),
          content: SizedBox(

            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Are you sure you want to delete room ${name}",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.black),),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(onPressed: onPress, text: AppLocalizations.of(context)!.delete,buttonWidth: 30,),
                    const SizedBox(
                      width: 10,
                    ),
                    ButtonWidget(onPressed: (){
                      Navigator.pop(context);
                    }, text: AppLocalizations.of(context)!.cancel,buttonWidth: 30,
                      color: Colors.black,),

                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }



  static rentDialog(BuildContext context, String name, double amount, double discount, {required Function(int) onPress}) {
    int selected = -1; // Track selected option

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white70,
              content: SizedBox(
                height: 300,
                width: Helper.dynamicWidth(context, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel, color: AppColors.btnColor),
                      ),
                    ),
                     Text(
                      AppLocalizations.of(context)!.rent_now,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      " ${AppLocalizations.of(context)!.you_are_renting} $name",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),

                    /// **Quick Watch - 1 Day Option**
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.imageBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected == 1 ? AppColors.btnColor : Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.quick_watch} ${calculateRent(amount, discount, 1)}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: selected == 1 ? AppColors.btnColor : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// **Weekly - 7 Day Option**
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.imageBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected == 2 ? AppColors.btnColor : Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.weekly} ${calculateRent(amount, discount, 7)}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: selected == 2 ? AppColors.btnColor : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// **Continue Button**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidget(
                          onPressed: () {
                            if (selected != -1) {
                              Navigator.pop(context); // Close dialog
                              onPress(selected); // Pass selected value
                            }
                          },
                          text: AppLocalizations.of(context)!.txt_continue,
                          buttonWidth: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String getOrderFormattedDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat("dd-MMM-yyyy").format(dateTime);
  }

  static String getOrderFormattedTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat("h:mm a").format(dateTime);
  }

  static Map<String, int> getRemainingTime(String targetTimeStr) {
    // Parse target date and time (UTC)
    DateTime targetTime = DateTime.parse(targetTimeStr).toUtc();

    // Current date and time (UTC)
    DateTime currentTime = DateTime.now().toUtc();

    // Time difference
    Duration difference = targetTime.difference(currentTime);

    // Extract days, hours, minutes, and seconds
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }



  static shareUrlDialog(var context,var url,  {required Null Function() onPress}){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          //  title: Text(heading),
          content: SizedBox(
            height: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TextRed(text: "Share Room link",),
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          Share.share(url, subject: 'Please join my room');
                        },
                        child: Icon(Icons.share,color: Colors.black,))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextWhite(text: "Successfully created your room. Share with other and enjoy your time.",fontSize: 16,),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                    width: 150,child: ButtonWidget(onPressed:onPress, text: "OK")),

              ],
            ),
          ),
        );
      },
    );
  }


  static successDialog(var context,var msg,  {required Null Function() onPress}){
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white38,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          //  title: Text(heading),
          content: SizedBox(
            height: 270,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset("assets/images/png/tick_circle.png",height: 80,color: Colors.white,)),
                SizedBox(
                  height: 20,
                ),
                TextWhite(text:msg,fontSize: 18,),
                SizedBox(
                  height: 20,
                ),
                ButtonWidget(onPressed:onPress, text: AppLocalizations.of(context)!.txt_continue,),

              ],
            ),
          ),
        );
      },
    );
  }


  static double getProgressPercentage(int watchedMinutes, int totalMinutes) {
    if (totalMinutes == 0) return 0.0; // Prevent division by zero
    return watchedMinutes / totalMinutes;
  }


}
