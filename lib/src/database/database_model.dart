
import 'package:database_manager/database_manager.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseModel {

  String _tableName;
  String _databaseName;
  Database _db;

  DatabaseModel({String dbName = 'database' }){
    _databaseName = dbName;
    _tableName = '';
    _db = DatabaseHelper().init( dbName: _databaseName, version: 1);
  }

}