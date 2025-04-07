import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class TVSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  TVSidebar({required this.selectedIndex, required this.onItemSelected});

  @override
  _TVSidebarState createState() => _TVSidebarState();


}

class _TVSidebarState extends State<TVSidebar> {
  int selectedIndex = 0; // Track focused item

  final List<Map<String, dynamic>> menuItems = [
    {"icon": "assets/images/png/home.png", "label": "Home"},
    {"icon": "assets/images/png/movies.png", "label": "Movies"},
    {"icon": "assets/images/png/songs.png", "label": "Music"},
    {"icon":"assets/images/png/search.png", "label": "Search"},
    {"icon": "assets/images/png/download.png", "label": "Downloads"},
    {"icon": "assets/images/png/mylist.png", "label": "Watchlist"},
    {"icon": "assets/images/png/more.png", "label": "More"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.black.withOpacity(0.9), // Netflix-like dark sidebar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Netflix Logo Placeholder
          Image.asset("assets/images/png/appIcon.png",width: 80,height: 40,),
          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    bool isSelected = selectedIndex == index;

    return FocusableActionDetector(
      onFocusChange: (focused) {
        if (focused) {
          widget.onItemSelected(index);
          setState(() {
            selectedIndex = index;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          widget.onItemSelected(index);
          print("${menuItems[index]['label']} Selected");
          setState(() {
            selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color:  Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Image.asset(menuItems[index]['icon'],
                    color: isSelected ? AppColors.btnColor :  Colors.white,  height: 24,width: 24),
                SizedBox(height: 5),
                Text(
                  menuItems[index]['label'],
                  style: TextStyle(
                    color: isSelected ? AppColors.btnColor :  Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
