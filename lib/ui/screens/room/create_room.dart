import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npflix/controller/create_room_controller.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../routes/index.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CreateRoom extends StatefulWidget {
  Map map;
  CreateRoom({super.key, required this.map});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  var isLoading =false;

  var toastmsg = CustomToast.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();

  TextEditingController roomNameController = TextEditingController();
  TextEditingController dateController =  TextEditingController();
  TextEditingController timeController =  TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 180)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != initialTime) {
      setState(() {
        initialTime = pickedTime;
        // Format time to AM/PM
        final hour = pickedTime.hourOfPeriod;
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';

        timeController.text = "$hour:$minute $period";
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastmsg.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    roomNameController.text = widget.map['name'];
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.profileScreenBackground,
          title:  TextHeading(text: AppLocalizations.of(context)!.create_seat),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Helper.dynamicHeight(context, 5),
                    ),

                    const TextHeading(text: "Create room"),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 3),
                    ),

                    SizedBox(
                      height: Helper.dynamicHeight(context, 1),
                    ),
                    TextWhite(text: AppLocalizations.of(context)!.room_name),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 1),
                    ),
                    TextField(
                      readOnly: true,
                      style:  TextStyle(color: Colors.white), //
                      controller: roomNameController,
                      decoration:  InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.profileScreenBackground, // Background color
                        contentPadding: EdgeInsets.symmetric(
                          //vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(0)

                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),

                        ),
                      ),
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),

                    GestureDetector(
                        onTap: (){
                          _selectDate(context);
                        },
                        child: TextWhite(text: AppLocalizations.of(context)!.select_date)),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 1),
                    ),
                    GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          style:  TextStyle(color: Colors.white), //
                          readOnly: true,
                          controller: dateController,
                          decoration:  InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: AppColors.profileScreenBackground, // Background color
                            contentPadding: EdgeInsets.symmetric(
                              //vertical: 10.0,
                              horizontal: 15.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(0)

                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),

                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    GestureDetector(
                        onTap: (){
                          _selectTime(context);
                        },
                        child: TextWhite(text: AppLocalizations.of(context)!.select_time)),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 1),
                    ),
                    GestureDetector(
                      onTap: (){
                        _selectTime(context);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          style:  TextStyle(color: Colors.white), //
                          controller: timeController,
                          readOnly: true,
                          decoration:  InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: AppColors.profileScreenBackground, // Background color
                            contentPadding: EdgeInsets.symmetric(
                              //vertical: 10.0,
                              horizontal: 15.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(0)

                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 25),
                    ),
                    Center(
                      child: ButtonWidget(
                          onPressed: () => {
                            createRoom(widget.map['id'])
                          },
                          text: "Create Room"
                      ),
                    ),

                  ],
                ),
              ),
            ),
            if(isLoading)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                        child: CircularProgressIndicator(

                        )
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
  createRoom(var id) async{
   if(roomNameController.text.isEmpty){
     toastmsg.showToast(context, message: "Please Enter Room Name");
   }else if(dateController.text.isEmpty){
     toastmsg.showToast(context, message: "Please Select Date");
   }else if(timeController.text.isEmpty){
     toastmsg.showToast(context, message: "Please Select Time");
   }else{
     setState(() {
       isLoading = true;
     });
     await Provider.of<CreateRoomController>(context, listen: false).createRoomPost(roomNameController.text.toString(),Helper.convertToISO8601(selectedDate.toString(), initialTime),id);
     if(Provider.of<CreateRoomController>(context, listen: false).createRoom.status == Status.COMPLETED) {

       setState(() {
         isLoading = false;
       });
       Helper.shareUrlDialog(context,Provider.of<CreateRoomController>(context, listen: false).createRoom.data.roomURL,
           onPress: (){
         Navigator.pop(context);
         Navigator.of(context)
             .pushNamedAndRemoveUntil(bottomNavigation, (route) => false,arguments: {"index" : 0});
       });
       toastmsg.showToast(context, message: "Room Created Successfully");
     } else if(Provider.of<CreateRoomController>(context, listen: false).createRoom.status == Status.ERROR) {
       setState(() {
         isLoading = false;
       });
       toastmsg.showToast(context, message: Provider.of<CreateRoomController>(context, listen: false).createRoom.message);

     }
   }

  }
}
