import 'package:flutter/material.dart';

import '../app_theme.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 80,
      color: MyTheme.kPrimaryColor,
      child: TabBar(
        controller: tabController,
        indicator: ShapeDecoration(
            color: MyTheme.kAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        tabs: [
          Tab(
            icon: Text('Chat', style: gettextstyle(22)),
          ),
          Tab(
            icon: Text('Map', style: gettextstyle(22)),
          ),
          Tab(
            icon: Text('Request', style: gettextstyle(22)),
          )
        ],
      ),
    );
  }

  TextStyle gettextstyle(double size) {
    return TextStyle(
      fontSize: size,
      fontFamily: "snap",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }
}
