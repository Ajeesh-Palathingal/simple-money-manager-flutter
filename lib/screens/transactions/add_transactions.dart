// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transactions/transaction_db.dart';
import 'package:money_management_app/models/Transactions/transactions_model.dart';
import 'package:money_management_app/models/category/category_model.dart';
import 'package:money_management_app/screens/category/category_add_popup.dart';

DateTime _invalidDate = DateTime.now().add(Duration(days: 1));

ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier(_invalidDate);
ValueNotifier<dynamic> dropdownNotifier = ValueNotifier("");
ValueNotifier<bool> validCategoryNotifier = ValueNotifier(true);
ValueNotifier<bool> validDateNotifier = ValueNotifier(true);

final _purposeController = TextEditingController();
final _amountController = TextEditingController();
String? _purpose;
double? _amount;
DateTime? _date;
String? _formatedDate;
CategoryType _categoryType = selectedCategoryNotifier.value;
CategoryModel? _categoryModel;

final _validatorKey = GlobalKey<FormState>();

bool _validDate = true;

class ScreenAddTransaction extends StatelessWidget {
  static const routeName = 'add-transaction-page';

  ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        //for removing bottom render overflow
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _validatorKey,
            child: Column(
              children: [
                // Purpose

                TextFormField(
                  controller: _purposeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can't be empty !!";
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Purpose", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),

                // Amount

                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can't be empty !!";
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Amount", border: OutlineInputBorder()),
                ),

                const SizedBox(
                  height: 12,
                ),

                // Category selection

                Row(
                  children: const [
                    RadioButton(title: "Income", type: CategoryType.income),
                    RadioButton(title: "Expense", type: CategoryType.expense)

                    // we can use radiobutton like this or we can use the RadioButton class which is already created. can use it as above

                    // Radio(
                    //     value: CategoryType.expense,
                    //     groupValue: selectedCategoryNotifier,
                    //     onChanged: ((value){}))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // Dropdown

                ValueListenableBuilder<CategoryType>(
                    valueListenable: selectedCategoryNotifier,
                    builder: (BuildContext context,
                        CategoryType newSelectedCategory, Widget? _) {
                      final _selectedCategoryModel = newSelectedCategory;
                      return ValueListenableBuilder(
                          valueListenable: dropdownNotifier,
                          builder: (BuildContext context, dynamic selected,
                              Widget? _) {
                            return DropdownButton(
                                value: selected,
                                hint: Text(_selectedCategoryModel ==
                                        CategoryType.income
                                    ? "Select Income Category"
                                    : "Select Expense Category"),
                                items: (_selectedCategoryModel ==
                                            CategoryType.income
                                        ? CategoryDB()
                                            .incomeCategoryListListener
                                        : CategoryDB()
                                            .expenseCategoryListListener)
                                    .value
                                    .map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                    onTap: () {
                                      _categoryModel = e;
                                    },
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {
                                  // print(
                                  //     "current dropdown notifier value ${dropdownNotifier.value}");
                                  dropdownNotifier.value =
                                      selectedValue.toString();

                                  print(selectedValue.toString());
                                });
                          });
                    }),
                ValueListenableBuilder(
                    valueListenable: validCategoryNotifier,
                    builder:
                        (BuildContext context, bool validCategory, Widget? _) {
                      return Visibility(
                          visible: !validCategory,
                          child: Text(
                            "You should select a category",
                            style: TextStyle(color: Colors.red),
                          ));
                    }),

                const SizedBox(
                  height: 10,
                ),

                // Date Picker

                ValueListenableBuilder(
                    valueListenable: selectedDateNotifier,
                    builder:
                        (BuildContext context, DateTime newDate, Widget? _) {
                      return TextButton.icon(
                          onPressed: () async {
                            final _selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 30)),
                                lastDate: DateTime.now());

                            if (_selectedDate == _invalidDate ||
                                _selectedDate == null) {
                              return;
                            } else {
                              _validDate = true;
                              selectedDateNotifier.value = _selectedDate;
                              _formatedDate = DateFormat.yMMMd().format(_selectedDate);

                              // print("Date $_formatedDate");

                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: Text(selectedDateNotifier.value == _invalidDate
                              ? "Select Date"
                              : _formatedDate!));
                    }),
                ValueListenableBuilder(
                    valueListenable: validDateNotifier,
                    builder: (BuildContext context, bool validDate, Widget? _) {
                      return Visibility(
                          visible: !validDate,
                          child: Text("You should select a date",
                              style: TextStyle(color: Colors.red)));
                    }),
                const SizedBox(
                  height: 12,
                ),

                // Button
                ElevatedButton(
                    onPressed: () {
                      _validatorKey.currentState!.validate();
                      validateForm(context);

                      // print(selectedCategoryNotifier.value);
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        ),
      )),
    );
  }

  validateForm(ctx) {
    // print(
    //     "purpose = ${_purposeController.text}\namnt ${_amountController.text}");

    // Dropdown validation
    if (dropdownNotifier.value != null || _categoryModel != null) {
      validCategoryNotifier.value = true;
    } else {
      validCategoryNotifier.value = false;
    }

    // print("selected date notifier value ${selectedDateNotifier.value}");
    // print("Invalid date $_invalidDate");

    // Date validation
    if (selectedDateNotifier.value != _invalidDate) {
      validDateNotifier.value = true;
      _date = selectedDateNotifier.value;
      // print("date ${selectedDateNotifier.value}");
    } else {
      validDateNotifier.value = false;
      return;
    }
    // (selectedDateNotifier.value == _invalidDate ||
    //         selectedDateNotifier.value == null
    //     ? validDateNotifier.value = false
    //     : validDateNotifier.value = true);

    // Purpose validation
    if (_purposeController.text != "") {
      _purpose = _purposeController.text;
    } else {
      return;
    }

    // Amount validation
    _amount = double.tryParse(_amountController.text);
    if (_amount == null) {
      return;
    }

    // type
    _categoryType = selectedCategoryNotifier.value;

    print("Validation completed");
    addTransactions();
    Navigator.of(ctx).pop();
  }

  Future<void> addTransactions() async {
    print("Add Transactions");
    print("type ${selectedCategoryNotifier.value}");

    final _transactionModel = TransactionModel(
        purpose: _purpose!,
        amount: _amount!,
        type: _categoryType,
        category: _categoryModel!,
        date: _date!);
    TransactionDB.instance.insertTransactions(_transactionModel);
  }
}
