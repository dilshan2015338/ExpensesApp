import 'package:expenses/db/account.dart';
import 'package:expenses/providers/account_state.dart';
import 'package:expenses/screens/add_expenses.dart';
import 'package:expenses/widgets/utills/expenses_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/account.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AccountState())
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Expenses details'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Account> accounts;
  bool isLoading = false;
  double totalValue = 0;

  @override
  void initState() {
    super.initState();

    refreshList();
  }

  Future refreshList() async {
    setState(() {
      isLoading = true;
    });

    this.accounts = await ExpensesDatabase.instance.readAllAccounts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('y MMMM d');
    var height = MediaQuery.of(context).size.height;
    final accountState = Provider.of<AccountState>(context);
    var size = MediaQuery.of(context).size;
    var cardHeight = size.width * 0.4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: isLoading
                  ? SizedBox(
                      height: height * 0.5,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              Text("Description",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              Text("Value",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("Blank",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: accounts.length,
                            itemBuilder: (context, index) {
                              Account account = accounts[index];
                              return ExpensesCard(
                                  cardWidth: size.width * 0.9,
                                  cardHeight: cardHeight * 0.4,
                                  account: account);
                            }),
                        Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                          height: cardHeight * 0.4,
                                          width: size.width * 0.96,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 4.0,
                                                )
                                              ]),
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      formatter.format(
                                                          DateTime.now()),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10)),
                                                  Text('Total',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10)),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            accountState
                                                                .calculateTotalCost(
                                                                    accounts)
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10)),
                                                        Opacity(
                                                          opacity: 0.0,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width:size.width* 0.08,
                                                                  height: size.width * 0.5,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                    },
                                                                    child: Icon(
                                                                      Icons.edit,size: 10,
                                                                    ),
                                                                    style: ElevatedButton.styleFrom(

                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:size.width* 0.08,
                                                                  height: size.width * 0.5,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                    },
                                                                    child: Icon(
                                                                      Icons.delete,size: 10,
                                                                    ),
                                                                    style: ElevatedButton.styleFrom(
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            accountState.changeUpdateStatus(false);
            accountState.cleanValues();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new AddExpenses(),
              ),
            );
          },
          child: Icon(Icons.add)),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
