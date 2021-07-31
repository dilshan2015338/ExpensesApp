import 'package:expenses/db/account.dart';
import 'package:expenses/main.dart';
import 'package:expenses/providers/account_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddExpenses extends StatefulWidget {
  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final accountState = Provider.of<AccountState>(context);
    return Scaffold(
      appBar: AppBar(
        title: accountState.update
            ? Text("Update Expenses")
            : Text("Create Expenses"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10 * 2, bottom: 10, right: 10 * 2),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter description";
                    }
                    return null;
                  },
                  controller: accountState.descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10 * 2, bottom: 10, right: 10 * 2),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter value";
                    }
                    return null;
                  },
                  controller: accountState.valueController,
                  decoration: InputDecoration(
                    labelText: "Value",
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    checkFormValidation(
                        _formKey,
                        accountState,
                        context);
                  },
                  child: accountState.update ? Text("Update") : Text("Add")),
            ],
          ),
        ),
      ),
    );
  }

  checkFormValidation(GlobalKey<FormState> _formKey,
      AccountState accountState, context) {
    if (_formKey.currentState!.validate()) {
      if (accountState.update) {
        accountState..updateValues().then((value) {
          Fluttertoast.showToast(
              msg: "Expeses updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.black,
              fontSize: 12);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new MyHomePage(title: "Expenses Details"),
            ),
          );
          
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
      } else {
        accountState.saveValues().then((value) {
          Fluttertoast.showToast(
              msg: "Expeses Saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.black,
              fontSize: 12);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new MyHomePage(title: "Expenses Details"),
            ),
          );
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
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 12);
    }
  }
}
