import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Connect {
  static final Connect _this = Connect._();

  String _dbName = 'database';
  Database _database;

  Connect._();

  factory Connect() {
    return _this;
  }

  Future<Database> get _db async {
    assert(
        _database != null ? true : throw 'database has not been initialized');
    return _database;
  }

  Future<Connect> init({String dbName = 'database', int version = 1}) async {
    _dbName = dbName;
    final String path = await _path();

    _database = await openDatabase(path, version: version);
    return this;
  }

  Future migrate({@required List<String> sqlMigrationsList}) async {
    final db = await _db;

    try {
      db.transaction((tran) async =>
          sqlMigrationsList.forEach((sql) async => await tran.execute(sql)));
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> raw({@required String sql}) async {
    Database db = await _db;

    db.rawQuery("PRAGMA foreign_keys = ON");

    return db.rawQuery(sql);
  }

  Future dropDatabase() async {
    _path().then((path) {
      deleteDatabase(path);
    });
  }

  Future _path() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "$_dbName.db");
  }
}
