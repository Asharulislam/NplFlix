import 'package:flutter/material.dart';
import 'package:npflix/ui/screens/bottomnavigation/tv_side_bar.dart';
import 'package:npflix/ui/screens/download/download_screen_tv.dart';
import 'package:npflix/ui/screens/home/Songs.dart';
import 'package:npflix/ui/screens/home/home_screen_tv.dart';
import 'package:npflix/ui/screens/home/movies.dart';
import 'package:npflix/ui/screens/more/more_screen_tv.dart';
import 'package:npflix/ui/screens/mylist/mylist_tv.dart';
import 'package:npflix/ui/screens/search/search_screen_tv.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0; // Track selected sidebar item

  final List<Widget> screens = [
    HomeScreenTv(),
    Movies(),
    Songs(),
    SearchScreenTv(),
    DownloadScreenTv(),
    MylistTv(),
    MoreScreenTv(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // 📌 Sidebar (Always Visible)
          TVSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          // 📌 Main Content (Changes when clicking Sidebar)
          Expanded(
            child: IndexedStack(
              index: selectedIndex, // Switch Screens without rebuilding
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}