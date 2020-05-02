import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/connection.dart';
import '../orm/query/query_builder.dart';

class ORMBuilder {
  final String tableName = '';

  QueryBuilder _query;
  Connection _connection;

  ORMBuilder() {
    _query = QueryBuilder();
  }

  Future<Connection> setConnection({Connection conn}) async {
    _connection = conn == null ? _connection : conn;
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
    Connection connection = await this.getConnection();
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

  Future<int> update(Map<String, dynamic> values) async {
    String wheres = _getWhere();
    List whereArgs = _getWhereArgs();

    Connection connection = await this.getConnection();
    Database db = connection.database;

    int cnt = 0;

    cnt =
        await db.update(tableName, values, where: wheres, whereArgs: whereArgs);

    return cnt;
  }

  Future<List<Map<String, dynamic>>> get([List<String> columns]) async {
    bool distinct = _getDistinct();
    int limit = _getLimit();
    int offset = _getOffset();
    String orderBy = _getOrderBy();
    String groupBy = _getGroupBy();
    String havings = _getHavings();
    List columnss = _getColumns();
    String wheres = _getWhere();
    List whereArgs = _getWhereArgs();

    Connection connection = await this.getConnection();
    Database db = connection.database;

    return await db.query(tableName,
        distinct: distinct,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        groupBy: groupBy,
        having: havings,
        columns: columns ?? columnss,
        where: wheres,
        whereArgs: whereArgs);
  }

  Future<int> count() async {
    final List get = await this.get();
    return get.length;
  }

  Future<Map<String, dynamic>> min(String column, {String alias = ''}) async {
    final List<Map<String, dynamic>> min =
        await this.select(['min($column) $alias']).limit(1).get();
    return min.first;
  }

  Future<Map<String, dynamic>> max(String column, {String alias = ''}) async {
    final List<Map<String, dynamic>> max =
        await this.select(['max($column) $alias']).limit(1).get();
    return max.first;
  }

  Future<Map<String, dynamic>> avg(String column, {String alias = ''}) async {
    final List<Map<String, dynamic>> max =
        await this.select(['avg($column) $alias']).limit(1).get();
    return max.first;
  }

  ORMBuilder select(List<String> columns) {
    _query.select(columns);
    return this;
  }

  ORMBuilder distinct([bool active = true]) {
    _query.setDistinct = active;
    return this;
  }

  ORMBuilder where(
      {@required String column,
      String operator = '=',
      dynamic value,
      String condition = 'AND'}) {
    _query.where(
        column: column,
        operator: operator,
        values: [value],
        condition: condition);
    return this;
  }

  ORMBuilder orWhere(
      {@required String column, String operator = '=', dynamic value}) {
    this.where(
        column: column, operator: operator, value: value, condition: 'OR');
    return this;
  }

  ORMBuilder whereIn(
      {@required String column,
      List<dynamic> values,
      String condition = 'AND'}) {
    _query.where(
        column: column, operator: 'IN', values: values, condition: condition);
    return this;
  }

  ORMBuilder orWhereIn({@required String column, List<dynamic> values}) {
    this.whereIn(column: column, values: values, condition: 'OR');
    return this;
  }

  ORMBuilder whereNotIn(
      {@required String column,
      List<dynamic> values,
      String condition = 'AND'}) {
    _query.where(
        column: column,
        operator: 'NOT IN',
        values: values,
        condition: condition);
    return this;
  }

  ORMBuilder orWhereNotIn({@required String column, List<dynamic> values}) {
    this.whereNotIn(column: column, values: values, condition: 'OR');
    return this;
  }

  /// Ordering, Grouping, Limit & Offset

  ORMBuilder orderBy({String column, String type, List<String> columns}) {
    _query.orderBy(column: column, type: type, columns: columns);
    return this;
  }

  ORMBuilder orderByDesc({String column, List<String> columns}) {
    this.orderBy(column: column, type: 'DESC', columns: columns);
    return this;
  }

  ORMBuilder orderByAsc({String column, List<String> columns}) {
    this.orderBy(column: column, type: 'ASC', columns: columns);
    return this;
  }

  ORMBuilder groupBy(List<String> columns) {
    _query.groupBy(columns);
    return this;
  }

  ORMBuilder limit(int value) {
    assert(
        value >= 0 ? true : throw 'Model $tableName: The limit must be> = 0');
    _query.setLimit = value;
    return this;
  }

  ORMBuilder offset(int value) {
    assert(
        value >= 0 ? true : throw 'Model $tableName: The offset must be> = 0');
    _query.setOffset = value;
    return this;
  }

  ORMBuilder having(
      {@required String column,
      String operator = '=',
      dynamic value,
      String condition = 'AND'}) {
    _query.having(
        column: column, operator: operator, value: value, condition: condition);
    return this;
  }

  ORMBuilder orHaving(
      {@required String column, String operator = '=', dynamic value}) {
    this.having(
        column: column, operator: operator, value: value, condition: 'OR');
    return this;
  }

  /// Aggregates

  bool _getDistinct() {
    return _query.distinct;
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

  int _getLimit() {
    return _query.limit;
  }

  int _getOffset() {
    return _query.offset;
  }

  String _getGroupBy() {
    String str = _query.groups;
    return str.isEmpty ? null : str;
  }

  String _getOrderBy() {
    String str = _query.orders;
    return str.isEmpty ? null : str;
  }

  String _getHavings() {
    String str = _query.havings;
    return str.isEmpty ? null : str;
  }
}
