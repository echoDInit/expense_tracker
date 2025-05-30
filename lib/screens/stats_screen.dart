import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/db_service.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Transaction> _transactions = [];
  final DBService _db = DBService();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final allTx = await _db.getAllTransactions();

    // 只取过去7天的数据
    final recentTx = allTx.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();

    setState(() {
      _transactions = recentTx;
    });
  }

  List<BarChartGroupData> _buildBarGroups() {
    final Map<String, double> dailyTotal = {};

    for (int i = 0; i < 7; i++) {
      final day = DateTime.now().subtract(Duration(days: i));
      final dayStr = DateFormat('yyyy-MM-dd').format(day);
      dailyTotal[dayStr] = 0;
    }

    for (var tx in _transactions) {
      final dayStr = DateFormat('yyyy-MM-dd').format(tx.date);
      if (dailyTotal.containsKey(dayStr)) {
        dailyTotal[dayStr] = dailyTotal[dayStr]! + tx.amount;
      }
    }

    final sortedKeys = dailyTotal.keys.toList()..sort();
    int i = 0;

    return sortedKeys.map((dayStr) {
      final amount = dailyTotal[dayStr]!;
      return BarChartGroupData(
        x: i++,
        barRods: [
          BarChartRodData(
            toY: amount,
            width: 14,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                return Text(DateFormat('E').format(day)); // 显示 Mon, Tue 等
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _transactions.isEmpty
            ? Center(child: Text('No recent transactions'))
            : _buildChart(),
      ),
    );
  }
}
