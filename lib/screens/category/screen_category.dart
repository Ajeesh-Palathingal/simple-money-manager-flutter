import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/screens/category/widget_expense_category_list.dart';
import 'package:money_management_app/screens/category/widget_income_category_list.dart';


class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>with SingleTickerProviderStateMixin {

  late TabController _tabController;
  
  @override
  void initState() {
    
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
      return  Column(
      children: [
        TabBar(
          labelColor: const Color.fromARGB(255, 0, 111, 100),
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: const[
            Tab(text: "INCOME",),
            Tab(text: "EXPENSE",)
        ]),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              IncomeCategoryList(),
              ExpenseCategoryList()
            ],)
          )
      ],
    );
    
    
  }
}