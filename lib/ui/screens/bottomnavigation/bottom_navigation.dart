import 'package:flutter/material.dart';
import 'package:npflix/ui/screens/download/download_screen.dart';
import 'package:npflix/ui/screens/home/home_screen.dart';
import 'package:npflix/ui/screens/home/home_screen_tv.dart';
import 'package:npflix/ui/screens/more/more_screen.dart';
import 'package:npflix/ui/screens/mylist/mylist.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:npflix/utils/helper_methods.dart';


class BottomNavigation extends StatefulWidget {
  Map map;
  BottomNavigation({Key? key,required this.map}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int pageIndex = 0;
  bool isIndexSet = false;

  final pages = [
    const HomeScreen(),
    const DownloadScreen(),
    const Mylist(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if(!isIndexSet){
      isIndexSet = true;
      pageIndex = widget.map['index'];
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: pages[pageIndex],
     //  body: IndexedStack(
     //    index: pageIndex, // Show the page corresponding to the current index
     //    children: pages,
     //  ),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: AppColors.appBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){
                setState(() {
                  pageIndex = 0;
                });
                },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/png/home.png" , height: 24,width: 24,color: pageIndex == 0 ? AppColors.btnColor :  Colors.white,),
                  pageIndex == 0 ? TextRed(text: AppLocalizations.of(context)!.home,fontSize: 9,) :  TextWhite(text: AppLocalizations.of(context)!.home,fontSize: 9,),
                ],
              )
          ),


          GestureDetector(
              onTap: (){
                setState(() {
                  pageIndex = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/png/download.png" , height: 24,width: 24,color: pageIndex == 1 ? AppColors.btnColor :  Colors.white,),
                  pageIndex == 1 ? TextRed(text: AppLocalizations.of(context)!.downloads,fontSize: 9) :  TextWhite(text: AppLocalizations.of(context)!.downloads,fontSize: 9),
                ],
              )
          ),

          GestureDetector(
              onTap: (){
                setState(() {
                  pageIndex = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/png/mylist.png" , height: 24,width: 24,color: pageIndex == 2 ? AppColors.btnColor :  Colors.white,),
                  pageIndex == 2 ? TextRed(text: AppLocalizations.of(context)!.my_list,fontSize: 9) :  TextWhite(text: AppLocalizations.of(context)!.my_list,fontSize: 9),
                ],
              )
          ),

          GestureDetector(
              onTap: (){
                setState(() {
                  pageIndex = 3;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/png/more.png" , height: 24,width: 24,color: pageIndex == 3 ? AppColors.btnColor : Colors.white,),
                  pageIndex == 3 ? TextRed(text: AppLocalizations.of(context)!.more,fontSize: 9) :  TextWhite(text: AppLocalizations.of(context)!.more,fontSize: 9),
                ],
              )
          ),

        ],
      ),
    );
  }
}
