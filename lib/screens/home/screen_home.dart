import 'package:flutter/material.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/screens/category/category_add_popup.dart';

import 'package:money_management_app/screens/category/screen_category.dart';
import 'package:money_management_app/screens/home/widget/bottom_navigation.dart';
import 'package:money_management_app/screens/transactions/add_transactions.dart';
import 'package:money_management_app/screens/transactions/screen_transactions.dart';

import '../../db/transactions/transaction_db.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selctedIndex = ValueNotifier(0);

  final _pages = const [ScreenTransactions(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {

    CategoryDB.instance.emptyListCheck();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 251, 246),
      bottomNavigationBar: MoneyManagementBottomNavigation(),
      appBar: AppBar(
        title: Text('Money Management'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selctedIndex,
            builder: (BuildContext ctx, int updatedIndex, Widget? _) {
              return _pages[updatedIndex];
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selctedIndex.value == 0) {
            print("Transactions");
            dropdownNotifier.value =
                null; // if not set as null conflict will occur in add transaction page. eg: let we selected a radiobutton income, then the dropdown will show the list of categories in income. if we try to change the radiobutton selection after selecting a category(item inside dropdown) of income in dropdown conflict will occure.
            await CategoryDB().refreshUI();
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            print("Category");
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: "Travel", type: CategoryType.expense);
            // CategoryDB().insertCategory(_sample);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
