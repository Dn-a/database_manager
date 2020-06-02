library orm_builder;

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../query/raw_query_builder.dart';
import '../query/query_builder.dart';

part 'operators_builder.dart';

typedef SubQueryCallback = void Function(OperatorBuilder query);

class ORMBuilder extends OperatorBuilder<ORMBuilder> {
  final String tableName = '';
  Database _connection;

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
      {bool noResult = true, bool continueOnError = false}) async {
    Database database = await this._getConnection();

    List<int> ids;
    await database.transaction((db) async {
      Batch btc = db.batch();
      values.forEach((value) => btc.insert(tableName, value));
      if (!noResult) {
        //final result = (await btc.commit()).map((result) => result is int ? result : null).cast<int>();
        final result =
            (await btc.commit(continueOnError: continueOnError)).cast<int>();
        ids = result;
      } else
        await btc.commit(noResult: true, continueOnError: continueOnError);
    }).catchError((e) => throw ('Transaction Error on $tableName:  $e'));

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

    return await database.query(
      tableName,
      distinct: distinct,
      columns: columns ?? queryColumns,
      where: wheres,
      whereArgs: whereArgs,
      orderBy: orderBy,
      groupBy: groupBy,
      limit: limit,
      offset: offset,
      having: havings,
    );
  }

  Future<int> delete() async {
    final String wheres = _getWhere();
    final List whereArgs = _getWhereArgs();

    _newInstanceQueryBuilder();

    Database database = await this._getConnection();

    return await database.delete(tableName,
        where: wheres, whereArgs: whereArgs);
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
}
