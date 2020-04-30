import 'dart:async';
import 'dart:io';
import 'package:database_manager/src/orm/query/query_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

typedef OnCreateCallback = void Function(Database db, int version);

class Connection {
  static final Connection _this = Connection._();

  String _dbName = 'database';
  Database _database;

  String _foreignKey = 'PRAGMA foreign_keys = ON';

  Connection._();

  factory Connection() {
    return _this;
  }

  Database get database {
    assert(
        _database != null ? true : throw 'database has not been initialized');
    return _database;
  }

  Future<Connection> init(
      {String dbName = 'database',
      int version = 1,
      OnCreateCallback onCreate}) async {
    _dbName = dbName;
    final String path = await _path();

    _database = await openDatabase(path, version: version, onCreate: onCreate);
    return this;
  }

  Future migrate({@required List<String> sqlMigrationsList}) async {
    final db = database;

    try {
      db.transaction((tran) async =>
          sqlMigrationsList.forEach((sql) async => await tran.execute(sql)));
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> raw({@required String sql}) async {
    Database db = database;

    if (_foreignKey.isNotEmpty) db.rawQuery(_foreignKey);

    return db.rawQuery(sql);
  }

  void foreignKeys({bool active = true}) {
    if (!active) _foreignKey = '';
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
