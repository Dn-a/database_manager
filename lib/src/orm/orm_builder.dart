import '../database/connection.dart';
import '../orm/query/query_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class ORMBuilder {
  final String tableName = '';
  Future<Connection> _connection;
  QueryBuilder _query;

  ORMBuilder({Future<Connection> connection}) : this._connection = connection {
    _query = QueryBuilder();
  }

  Future<Connection> setConnection() async {
    return _connection;
  }

  Future<Connection> getConnection() async {
    Connection connection = await this.setConnection();
    assert(connection != null
        ? true
        : throw "ORMBuilder: Connection is not initialized");
    return connection;
  }

  Future<List<int>> insert(List<Map<String, dynamic>> values) async {
    Connection connection = await this.setConnection();
    Database db = connection.database;

    final List<int> ids = [];

    await db.transaction((db) async {
      values.forEach((value) async {
        ids.add(await db
            .insert(tableName, value)
            .catchError((e) => print('Insert on $tableName: $e')));
      });
    });

    return ids;
  }

  Future<List<Map<String, dynamic>>> get([List<String> columns]) async {
    Connection connection = await this.setConnection();
    Database db = connection.database;

    return db.query(tableName,
        columns: columns ?? _getColumns(),
        where: _getWhere(),
        whereArgs: _getWhereArgs());
  }

  ORMBuilder select(List<String> columns) {
    _query.select(columns: columns);
    return this;
  }

  ORMBuilder where({
    @required String column,
    String operator = '=',
    dynamic value,
  }) {
    _query.where(column: column, operator: operator, values: [value]);
    return this;
  }

  ORMBuilder orWhere({
    @required dynamic column,
    String operator = '=',
    dynamic value,
  }) {
    _query.where(
        column: column, operator: operator, values: [value], condition: 'OR');
    return this;
  }

  ORMBuilder whereIn({@required String column, List<dynamic> values}) {
    _query.where(column: column, operator: 'IN', values: values);
    return this;
  }

  ORMBuilder whereNotIn({@required String column, List<dynamic> values}) {
    _query.where(column: column, operator: 'NOT IN', values: values);
    return this;
  }

  List<String> _getColumns() {
    return _query.columns;
  }

  String _getWhere() {
    String str = _query.whereColumns;
    return str.isEmpty ? null : str;
  }

  List<dynamic> _getWhereArgs() {
    return _query.wheresArgs;
  }
}
