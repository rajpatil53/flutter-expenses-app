import 'package:flutter/material.dart';

import './widgets/transaction-list.dart';
import './widgets/add-transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(id: '1', title: "Item", amount: 1000, date: DateTime.now()),
    Transaction(id: '2', title: "Item", amount: 1000, date: DateTime.now()),
    Transaction(id: '4', title: "Item", amount: 1000, date: DateTime.now()),
    Transaction(id: '5', title: "Item", amount: 1000, date: DateTime.now()),
    Transaction(id: '6', title: "Item", amount: 1000, date: DateTime.now()),
    Transaction(id: '7', title: "Item", amount: 1000, date: DateTime.now()),
  ];

  bool _showChart = false;

  void _toggleChart(val) {
    setState(() {
      _showChart = val;
    });
  }

  void _addTransaction(String txTitle, double txAmount, DateTime txDate) {
    Transaction newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _openAddModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Expenses"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openAddModal(context),
        )
      ],
    );

    Widget _displayChart(heightRatio){
      return Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            heightRatio,
        child: Chart(
          _recentTransaction,
        ),
      );
    } 
    Widget _displayList(heightRatio){
      return Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            heightRatio,
        child: TransactionList(
          _transactions,
          _deleteTransaction,
        ),
      );
    } 

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Show Chart"),
                Switch(
                  value: _showChart,
                  onChanged: (val) => _toggleChart(val),
                ),
              ],
            ),
            if(isLandscape) _showChart ? _displayChart(0.6) : _displayList(0.8),
            if(!isLandscape) _displayChart(0.3),
            if(!isLandscape) _displayList(0.7)
            // list,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openAddModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
