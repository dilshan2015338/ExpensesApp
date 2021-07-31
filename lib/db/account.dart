import 'package:expenses/models/account.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesDatabase {
  static final ExpensesDatabase instance = ExpensesDatabase._init();

  static Database? _database;

  ExpensesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB("account.db");
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final strType = "VARCHAR(255)";
    final valueType = "DOUBLE";
    final dateType = "DATETIEM";

    await db.execute('''
    CREATE TABLE $tableAccount (
    ${AccountFields.id} $idType,
    ${AccountFields.description} $strType,
    ${AccountFields.value} $valueType,
    ${AccountFields.date} $dateType
    )
    ''');
  }

  Future<Account> create(Account account) async {
    final db = await instance.database;
    final id = await db!.insert(tableAccount, account.toJson());
    return account.copy(id: id);
  }

  Future<Account> readAccount(int id) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableAccount,
      columns: AccountFields.values,
      where: '${AccountFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Account.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Account>> readAllAccounts() async {
    final db = await instance.database;
    final orderBy = '${AccountFields.date} ASC';
    final results = await db!.query(tableAccount, orderBy: orderBy);

    return results.map((json) => Account.fromJson(json)).toList();
  }

  Future<int> update(Account account) async {
    final db = await instance.database;
    return db!.update(
      tableAccount,
      account.toJson(),
      where: '${AccountFields.id} == ?',
      whereArgs: [account.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db!.delete(tableAccount,
        where: '${AccountFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
