import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function deleteTx;

  TransactionList(this._transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 410,
      child: _transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Text("No transactions added yet!"),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset("assets/images/waiting.png"),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              "₹ ${_transactions[index].amount.toStringAsFixed(2)}"),
                        ),
                      ),
                    ),
                    title: Text(
                      _transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(_transactions[index].date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? FlatButton.icon(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => deleteTx(_transactions[index].id),
                            label: Text("Delete"),
                            textColor: Theme.of(context).errorColor,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => deleteTx(_transactions[index].id),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
