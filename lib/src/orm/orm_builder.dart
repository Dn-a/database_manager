import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../orm/query/query_builder.dart';

typedef SubQueryCallback = void Function(ORMBuilder query);

class ORMBuilder {
  final String tableName = '';

  QueryBuilder _query;
  Database _connection;

  ORMBuilder() {
    _query = QueryBuilder();
  }

  /// The same [ORMBuilder] instance can be used to perform different queries.
  /// After an insert, an update or a get it is necessary to perform a reset
  /// to allow the creation of new queries with the same ORMBuilder instance.
  /// To allow this you need to create a new [QueryBuilder] instance
  void _newInstanceQueryBuilder() => _query = QueryBuilder();

  Future<Database> setConnection({Database conn}) async {
    _connection = conn == null ? _connection : conn;
    return _connection;
  }

  Future<Database> _getConnection() async {
    Database database = await this.setConnection();
    assert(database != null
        ? true
        : throw "ORMBuilder: Connection is not initialized");
    return database;
  }

  /// Returns a list of the last IDs entered if onResult = false, otherwise it returns an empty list
  /// onResult is active by default because the result of each insertion reduces performance
  Future<List<dynamic>> insert(List<Map<String, dynamic>> values,
      {bool noResult = true, bool continueOnError = false }) async {
    Database database = await this._getConnection();

    List<int> ids;
    await database.transaction((db) async {
      Batch btc = db.batch();
      values.forEach((value) => btc.insert(tableName, value) );
      if(!noResult){
        //final result = (await btc.commit()).map((result) => result is int ? result : null).cast<int>();
        final result = (await btc.commit(continueOnError: continueOnError)).cast<int>();
        ids = result;
      }else
        await btc.commit(noResult: true, continueOnError: continueOnError);
    }).catchError((e) => throw('Transaction Error on $tableName:  $e'));

    return ids;
  }

  Future<int> update(Map<String, dynamic> values) async {
    final String wheres = _getWhere();
    final List whereArgs = _getWhereArgs();

    _newInstanceQueryBuilder();

    Database database = await this._getConnection();

    return await database.update(tableName, values,
        where: wheres, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> get([List<String> columns]) async {
    final bool distinct = _getDistinct();
    final int limit = _getLimit();
    final int offset = _getOffset();
    final String orderBy = _getOrderBy();
    final String groupBy = _getGroupBy();
    final String havings = _getHavings();
    final List queryColumns = _getColumns();
    final String wheres = _getWhere();
    final List whereArgs = _getWhereArgs();

    _newInstanceQueryBuilder();

    Database database = await this._getConnection();

    return await database.query(tableName,
        distinct: distinct,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        groupBy: groupBy,
        having: havings,
        columns: columns ?? queryColumns,
        where: wheres,
        whereArgs: whereArgs);
  }

  Future<int> delete() async {
    final String wheres = _getWhere();
    final List whereArgs = _getWhereArgs();

    _newInstanceQueryBuilder();

    Database database = await this._getConnection();

    return await database.delete(tableName, where: wheres, whereArgs: whereArgs);
  }

  /// Aggregates

  Future<int> count() async {
    final List get = await this.get(['count(*) cnt']);
    return get.first['cnt'];
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

  ORMBuilder from(String table) {
    _query.from(table: table);
    return this;
  }

  ORMBuilder distinct([bool active = true]) {
    _query.setDistinct = active;
    return this;
  }

  ORMBuilder where(
      {
      String column,
      String operator = '=',
      @required dynamic value,
      String condition = 'AND',
      SubQueryCallback nested}) {

    if(nested!=null)
      nested(_subQuery());
    else
      _query.where(
          column: column,
          operator: operator,
          values: [value],
          condition: condition);

    return this;
  }

  /// create a sub-query
  ORMBuilder _subQuery(){
    final ORMBuilder queryBuilder = ORMBuilder();
    return queryBuilder;
  }

  ORMBuilder orWhere(
      {String column, String operator = '=', dynamic value}) {
    this.where(column: column, operator: operator, value: value, condition: 'OR');
    return this;
  }

  ORMBuilder whereIn(
      {
      String column,
      List<dynamic> values,
      String condition = 'AND'}) {
    _query.where(
        column: column, operator: 'IN', values: values, condition: condition);
    return this;
  }

  ORMBuilder orWhereIn({String column, List<dynamic> values}) {
    this.whereIn(column: column, values: values, condition: 'OR');
    return this;
  }

  ORMBuilder whereNotIn(
      {String column, List<dynamic> values,
      String condition = 'AND'}) {
    _query.where(
        column: column,
        operator: 'NOT IN',
        values: values,
        condition: condition);
    return this;
  }

  ORMBuilder orWhereNotIn({String column, List<dynamic> values}) {
    this.whereNotIn(column: column, values: values, condition: 'OR');
    return this;
  }

  /// Ordering, Grouping, Limit & Offset

  ORMBuilder orderBy(List<String> columns, {String type}) {
    _query.orderBy(columns, type: type);
    return this;
  }

  ORMBuilder orderByDesc(List<String> columns) {
    this.orderBy(columns, type: 'DESC');
    return this;
  }

  ORMBuilder orderByAsc(List<String> columns) {
    this.orderBy(columns, type: 'ASC');
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
