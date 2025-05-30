import 'package:hive/hive.dart';
import '../models/transaction.dart';

class DBService {
  static const String boxName = 'transactions';

  // 打开 box，建议在 app 启动时只调用一次（main.dart 中 init）
  Future<Box<Transaction>> _getBox() async {
    return await Hive.openBox<Transaction>(boxName);
  }

  Future<void> addTransaction(Transaction transaction) async {
    final box = await _getBox();
    await box.add(transaction);
  }

  Future<List<Transaction>> getAllTransactions() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> deleteTransaction(int index) async {
    final box = await _getBox();
    await box.deleteAt(index);
  }

  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
