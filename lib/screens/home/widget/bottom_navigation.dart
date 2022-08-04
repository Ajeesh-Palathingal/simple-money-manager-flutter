import 'package:flutter/material.dart';

import 'package:money_management_app/screens/home/screen_home.dart';

class MoneyManagementBottomNavigation extends StatelessWidget {
  const MoneyManagementBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selctedIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          currentIndex: updatedIndex,
          onTap: (newIndex){
            ScreenHome.selctedIndex.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Transactions"),
            BottomNavigationBarItem(icon: Icon(Icons.category),label: "Category")
          ]);
      }
    );
  }
}