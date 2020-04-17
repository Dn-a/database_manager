import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _this = DatabaseHelper._();

  String _dbName = 'database';
  Database _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _this;
  }

  Future<Database> get _db async {
    assert(
    _database != null ? true : throw 'database has not been initialized');
    return _database;
  }

  Future<DatabaseHelper> init({String dbName = 'database', int version = 1}) async {
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

    if(_fk.isNotEmpty)
      db.rawQuery(_fk);

    return db.rawQuery(sql);
  }

  String _fk = 'PRAGMA foreign_keys = ON';

  void foreignKeys({bool active = true }){
    if(!active)
      _fk = '';
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
