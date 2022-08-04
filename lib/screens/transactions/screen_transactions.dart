import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/db/transactions/transaction_db.dart';
import 'package:money_management_app/models/Transactions/transactions_model.dart';
import 'package:money_management_app/models/category/category_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    
      
      return ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder: (BuildContext context, List<TransactionModel> newList,
              Widget? _) {
                
                if (TransactionDB.instance.transactionListNotifier.value.isEmpty) {
      // print("List empty");
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("No transactions available.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey),),
          Text("Add transactions by pressing + icon.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey),)
        ],
      ));
    } else {
            return ListView.separated(

                // Values are displayed here
                itemBuilder: (BuildContext context, int index) {
                  final _value = newList[index];
                  return Slidable(
                    key: Key(_value.id!),
                    startActionPane:
                        ActionPane(motion: DrawerMotion(), children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          TransactionDB.instance.deleteTransaction(_value.id!);
                        },
                        icon: Icons.delete,
                        label: "Remove",
                        foregroundColor: Colors.red,
                      )
                    ]),
                    child: Card(
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            parseDate(_value.date),
                            textAlign: TextAlign.center,
                          ),
                          radius: 30,
                          backgroundColor: _value.type == CategoryType.expense
                              ? Colors.red
                              : Colors.green,
                        ),
                        title: Text("Rs:${_value.amount}"),
                        subtitle: Text(_value.category.name),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: newList.length);
    }
          });
    
  }

  String parseDate(DateTime date) {
    print("Empty or not ${TransactionDB.instance.transactionListNotifier}");
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(" ");
    return "${_splitedDate.last}\n${_splitedDate.first}";
    // return "${date.day}\n${date.month}";
  }
}
