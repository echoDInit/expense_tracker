import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/db_service.dart';

class AddTxScreen extends StatefulWidget {
  final Transaction? existingTx;
  final int? txIndex;

  const AddTxScreen({super.key, this.existingTx, this.txIndex});

  @override
  State<AddTxScreen> createState() => _AddTxScreenState();
}

class _AddTxScreenState extends State<AddTxScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  @override
  initState() {
    super.initState();
    if (widget.existingTx != null) {
      _titleController.text = widget.existingTx!.title;
      _amountController.text = widget.existingTx!.amount.toString();
      _selectedDate = widget.existingTx!.date;
      _selectedCategory = widget.existingTx!.category;
    }
  }

  void _submit() async {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter valid values')));
      return;
    }

    final tx = Transaction(
      title: title,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    if (widget.txIndex != null) {
      await DBService().deleteTransaction(widget.txIndex!);
    }
    await DBService().addTransaction(tx);

    Navigator.pop(context, true); // 通知刷新
  }


  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              items: ['Food', 'Transport', 'Shopping', 'Others']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            Row(
              children: [
                Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                TextButton(onPressed: _pickDate, child: Text('Change')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
