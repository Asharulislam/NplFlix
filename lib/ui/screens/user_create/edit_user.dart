import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';

import '../../../utils/helper_methods.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title:  TextHeading(text: AppLocalizations.of(context)!.manage_profile),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Helper.dynamicHeight(context, 20),
                ),
                Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context)
                            .pushNamed(createUserName);
                      },
                      child: SizedBox(
                        width: 195,
                          height: 180,
                          child: Stack(
                            children: [
                              Image.asset("assets/images/png/userIcon.png",width: 195,height: 180,),
                              Center(
                                  child:  Icon(Icons.edit,color: Colors.white,size: 43,)
                              )
                            ],
                          )
                      ),
                    )
                ),
                SizedBox(
                  height: Helper.dynamicHeight(context, 1),
                ),
                const TextWhite(text: "Emenalo")
              ],
            ),
          )
        )
    );
  }
}
