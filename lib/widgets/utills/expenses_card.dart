import 'package:expenses/main.dart';
import 'package:expenses/models/account.dart';
import 'package:expenses/providers/account_state.dart';
import 'package:expenses/screens/add_expenses.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final Account account;
  const ExpensesCard(
      {Key? key,
      required this.cardWidth,
      required this.cardHeight,
      required this.account})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('y MMMM d');
    final accountState = Provider.of<AccountState>(context);
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            height: cardHeight * 0.8,
            width: cardWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
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
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatter.format(account.date),
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                    Text('${account?.description}',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                    Container(
                      child: Row(
                        children: [
                          Text('${account?.value}',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:width* 0.08,
                                  height: width * 0.5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      accountState.changeUpdateStatus(true);
                                      accountState.setValues(account);
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new AddExpenses(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,size: 10,
                                    ),
                                    style: ElevatedButton.styleFrom(

                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    accountState.setValues(account);
                                    accountState.deleteValues().then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Expense deleted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent,
                                          textColor: Colors.black,
                                          fontSize: 12);
                                    }).catchError((onError) {
                                      print(onError.toString());
                                      Fluttertoast.showToast(
                                          msg: onError.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent,
                                          textColor: Colors.black,
                                          fontSize: 12);
                                    });

                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new MyHomePage(
                                            title: "Expenses Details"),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,size: 10,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(width * 0.001, width * 0.01),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
