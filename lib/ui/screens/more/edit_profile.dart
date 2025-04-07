import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/edit_text.dart';

import '../../../sources/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/button.dart';
import '../../widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = SharedPreferenceManager.sharedInstance.getString("userName") ?? "";
    emailController.text =  SharedPreferenceManager.sharedInstance.getString("userEmail") ?? "";
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.edit_profile),
          iconTheme: const IconThemeData(color: AppColors.btnColor),
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 5),
                ),
                Center(
                  child:  Image.asset("assets/images/png/userIcon.png",width: 70,height: 70,),
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 3),
                ),
                TextFieldWithCustomIcon(icon: Icons.person, label:AppLocalizations.of(context)!.first_name,controller: nameController,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                TextFieldWithCustomIcon(icon: Icons.email, label: AppLocalizations.of(context)!.email,controller: emailController,),
                SizedBox(
                  height: Helper.dynamicHeight(context, 2),
                ),
                TextFieldWithCustomIcon(icon: Icons.phone, label: "Phone Number",controller: numberController,),
                //Spacer(),
                SizedBox(
                  height: Helper.dynamicHeight(context, 20),
                ),
                ButtonWidget(
                    buttonWidth: 100,
                    onPressed: () => {
                      Navigator.pop(context)
                    },
                    text: "Save"
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 5),
                ),
            
            
              ],
            ),
          ),
        ),


      ),
    );
  }
}
