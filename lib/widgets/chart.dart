import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart-bar.dart';

class Chart extends StatelessWidget {
  final _recentTransactions;

  Chart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var total = 0.0;

      for (int i = 0; i < _recentTransactions.length; i++) {
        if (_recentTransactions[i].date.day == weekDay.day &&
            _recentTransactions[i].date.month == weekDay.month &&
            _recentTransactions[i].date.year == weekDay.year) {
          total += _recentTransactions[i].amount;
        }
      }

      return {"day": DateFormat.E().format(weekDay), "amount": total};
    }).reversed.toList();
  }

  double get totalAmount {
    return groupedTransactionValues.fold(0.0, (sum, tx) {
      return sum += tx["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((tx) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  tx["day"],
                  tx["amount"],
                  totalAmount == 0.0 ? 0.0 : (tx["amount"] as double) / totalAmount,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
