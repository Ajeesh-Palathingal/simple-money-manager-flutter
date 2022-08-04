import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transactions/transaction_db.dart';
import 'package:money_management_app/models/Transactions/transactions_model.dart';
import 'package:money_management_app/models/category/category_model.dart';

import 'package:money_management_app/screens/home/screen_home.dart';
import 'package:money_management_app/screens/transactions/add_transactions.dart';

Future<void> main() async {
  
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  await TransactionDB.instance.refreshUI();
  await CategoryDB.instance.refreshUI();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ScreenHome(),
      routes: {ScreenAddTransaction.routeName: (ctx) => ScreenAddTransaction()},
    );
  }
}
