
import '../database/connection.dart';
import '../orm/query/query_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class ORMBuilder {

  final String tableName = '';

  final Future<Connection> connection;

  QueryBuilder _query;

  ORMBuilder({this.connection}){
    _query = QueryBuilder();
  }

  Future<List<Map<String, dynamic>>> get({@required List<String> column }) async {
    Connection conn = await connection;
    Database db = conn.database;

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
