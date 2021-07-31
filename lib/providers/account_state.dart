

import 'package:expenses/db/account.dart';
import 'package:expenses/models/account.dart';
import 'package:flutter/material.dart';

class AccountState extends ChangeNotifier {

  int id= 0;
  DateTime date= DateTime.now();
  double total = 0;
  bool update=false;

  //Controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  Future<Account> saveValues(){
      Account account = new Account(description: descriptionController.text, value: double.parse(valueController.text), date: DateTime.now());
      return ExpensesDatabase.instance.create(account);
  }

  Future<int> updateValues(){
    Account account = new Account(id:this.id,description: descriptionController.text, value: double.parse(valueController.text), date: this.date);
    return ExpensesDatabase.instance.update(account);
  }

  Future<int> deleteValues(){
    return ExpensesDatabase.instance.delete(this.id);
  }

  void changeUpdateStatus(bool status){
    update = status;
    notifyListeners();
  }

  void setValues(Account account){
    this.id = account.id!;
    this.descriptionController.text = account.description;
    this.valueController.text = account.value.toString();
    this.date = account.date;
    notifyListeners();
  }

  void cleanValues(){
    this.id =0;
    this.descriptionController.text ='';
    this.valueController.text = '';
    this.date = DateTime.now();
    notifyListeners();
  }

  double calculateTotalCost(List<Account> accountList){
    double sum =0;
    for (int i = 0; i < accountList.length; i++){
      Account account = accountList[i];
      sum += account.value;
    }
    return sum;
  }

}