import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app/models/category/category_model.dart';
part 'transactions_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String purpose;

  @HiveField(2)

  final double amount;

  @HiveField(3)

  final CategoryType type;

  @HiveField(4)
  final CategoryModel category;

  @HiveField(5)
  final DateTime date;

  TransactionModel({
      required this.purpose,
      required this.amount,
      required this.type,
      required this.category,
      required this.date
    }){
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }
}
