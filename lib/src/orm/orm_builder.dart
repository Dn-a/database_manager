
import '../database/connection.dart';
import '../orm/query/query_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class ORMBuilder {

  final String tableName = '';
  Connection _connection;
  QueryBuilder _query;

  ORMBuilder() {
    _query = QueryBuilder();
  }

  Future<Connection> setConnection({Connection connection}) async {
    return connection;
  }

  Future<Connection> getConnection() async {
    _connection = await this.setConnection();
    assert( _connection!=null ? true : throw "ORMBuilder: Connection is not initialized" );

    return _connection;
  }

  Future<dynamic> insert({ List<Map<String,dynamic>> values }) async {
    Connection connection = await this.getConnection();
    Database db = connection.database;

    return db.transaction((db) async{
      return values.forEach((value) async {
        return await db.insert(tableName, value);
      });
    });
  }

  Future<List<Map<String, dynamic>>> get({ List<String> column }) async {
    Connection connection = await this.getConnection();
    Database db = connection.database;

    return db.query(tableName);
  }


  ORMBuilder where({
    @required dynamic column,
    String operator = '=',
    dynamic value,
  }) {
     _query.where(column: column, operator: operator, value: value);
     return this;
  }

  ORMBuilder orWhere({
    @required dynamic column,
    String operator = '=',
    dynamic value,
  }) {
    _query.where(column: column, operator: operator, value: value, condition: 'OR');
    return this;
  }

}
