import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/screens/History.dart';
import 'package:monitor_lizard/screens/Home.dart';
import 'package:monitor_lizard/screens/Settings.dart';

class BottomTabNav extends StatefulWidget {
  const BottomTabNav({Key? key}) : super(key: key);

  @override
  State<BottomTabNav> createState() => _BottomTabNavState();
}

class _BottomTabNavState extends State<BottomTabNav> {
  int currentPageIndex = 0;
  List<Widget> BottomNavPages = [
    const Home(),
    const History(),
    const Settings(),
  ];

  void onTabSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BottomNavPages.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.gray,
        onTap: onTabSelected,
        currentIndex: currentPageIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
      ),
    );
  }
}
