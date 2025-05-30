import 'package:hive/hive.dart';

part 'transaction.g.dart';  // 生成的代码将写入这个文件

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

// class Transaction {
//   final int id;
//   final String title;
//   final double amount;
//   final DateTime date;
//   final String category;  // eg：'food', 'entertainment等
//
//   Transaction({
//     required this.id,
//     required this.title,
//     required this.amount,
//     required this.date,
//     required this.category,
//   });
//
//   factory Transaction.fromMap(Map<String, dynamic> data) {
//     return Transaction(
//       id: data['id'],
//       title: data['title'],
//       amount: data['amount'],
//       date: DateTime.parse(data['date']),
//       category: data['category'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'category': category,
//     };
//   }
// }