import 'package:flutter/material.dart';
import 'package:npflix/controller/create_user_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:npflix/ui/widgets/button.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateUserName extends StatefulWidget {
  const CreateUserName({super.key});

  @override
  State<CreateUserName> createState() => _CreateUserNameState();
}

class _CreateUserNameState extends State<CreateUserName> {
  TextEditingController userTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Helper.dynamicHeight(context, 1),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/png/barimg.png",width: 100,height: 42,),
                        const Spacer(),
                        InkWell(
                            onTap: (){
                              Navigator.of(context)
                                  .pushNamed(help);
                            },
                            child:  TextWhite(text: AppLocalizations.of(context)!.help)
                        )
                      ],
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 5),
                    ),
                    PlanTextBold(text:AppLocalizations.of(context)!.who_will_be_watching_nplflix,textAlign: TextAlign.start,fontSize: 20,),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 2),
                    ),
                    TextWhite(text: AppLocalizations.of(context)!.everyone_in_your_household_can_enjoy_suggestion_based_on_their_own_viewing_and_tastes_great_for_kids,textAlign: TextAlign.start,),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 5),
                    ),
                    TextField(
                      controller: userTextController,
                      style:  const TextStyle(color: Colors.white), //
                      decoration:  InputDecoration(
                        hintText: AppLocalizations.of(context)!.your_profile,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundColor, // Background color
                        contentPadding: const EdgeInsets.symmetric(
                          //vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(0)

                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),

                        ),
                      ),
                    ),
                    SizedBox(
                      height: Helper.dynamicHeight(context, 30),
                    ),

                    Center(
                      child: ButtonWidget(
                          buttonWidth: 100,
                          onPressed: () => {
                            _createUser()
                          },
                          text: AppLocalizations.of(context)!.txt_continue
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
                  Center(
                      child: CircularProgressIndicator(

                      )
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  var isLoading = false;
  var toastmsg = CustomToast.instance;
  _createUser() async{
    if(!isLoading){
      if(userTextController.text.isEmpty){
        toastmsg.showToast(context, message: "Enter Name");
        debugPrint("Please enter email");
      } else{
        setState(() {
          isLoading = true;
        });
        var id = await SharedPreferenceManager.sharedInstance.getString("userId");
        await Provider.of<CreateUserController>(context, listen: false).createUser(id,userTextController.text.toString());
        if(Provider.of<CreateUserController>(context, listen: false).user.status == Status.COMPLETED){
          setState(() {
            isLoading = false;
          });
          SharedPreferenceManager.sharedInstance.storeString("userName", userTextController.text.toString());

          Navigator.of(context)
              .pushNamed(selectUser);
        } else if(Provider.of<CreateUserController>(context, listen: false).user.status == Status.ERROR){
          toastmsg.showToast(context, message: Provider.of<CreateUserController>(context, listen: false).user.message);
          setState(() {
            isLoading = false;
          });
        }
      }
    }

  }
}
