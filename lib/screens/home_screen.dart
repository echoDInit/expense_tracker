import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/db_service.dart';
import 'add_tx_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBService db = DBService();
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await db.getAllTransactions();
    setState(() {
      _transactions = data;
    });
  }

  Future<void> _deleteTransaction(int index) async {
    await db.deleteTransaction(index);
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: _transactions.isEmpty
          ? Center(child: Text('No transactions yet.'))
          : ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (ctx, i) {
          final tx = _transactions[i];
          return ListTile(
            title: Text(tx.title),
            subtitle: Text('${tx.category} • ${DateFormat('h:mm a - MMM d, yyyy').format(tx.date)}',),
            trailing: Text('\$${tx.amount.toStringAsFixed(2)}'),
            onTap: () async {
              final shouldReload = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTxScreen(
                    existingTx: tx,
                    txIndex: i,
                  ),
                ),
              );
              if (shouldReload == true) {
                _loadTransactions();
              }
            },
            onLongPress: () async {
              await _deleteTransaction(i);
            },

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldReload = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTxScreen()),
          );
          if (shouldReload == true) {
            _loadTransactions(); // 刷新
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
