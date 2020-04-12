import 'package:flutter/foundation.dart';

import 'blueprint.dart';

typedef SchemaCallback = void Function(Blueprint table);

class Schema {
  static Map<String, Blueprint> _tables = {};
  static Map<String, String> _dropTables = {};

  /// Returns SQL from a single table
  static String getSQL({@required String tableName}) {
    return _generateSql(tableName: tableName);
  }

  /// Returns SQL from all table
  static String getSQLAllTable() {
    return _generateSqlFromAllTable();
  }

  static List<String> getSQLList() {
    return _generateSqlList();
  }

  static List<String> getAllDropSQL() {
    final List<String> list = [];
    _dropTables.forEach((name, sql) => list.add(sql));
    return list;
  }

  static create(
      {@required String tableName, @required SchemaCallback callback}) {
    Blueprint table = Blueprint();
    callback(table);

    _addTable(tableName: tableName, table: table);
  }

  static table(
      {@required String tableName, @required SchemaCallback callback}) {
    assert(_tables[tableName] != null
        ? true
        : throw "The $tableName table does not exist");

    Blueprint table = _tables[tableName];
    callback(table);
  }

  static dropIfExists({String tableName}) {
    final bool check = _tables.containsKey(tableName);
    assert(check ? true : throw "The $tableName table does not exist");

    _dropTables
        .addAll({tableName: _generateSQLDropTable(tableName: tableName)});
  }

  static void _addTable({String tableName, Blueprint table}) {
    final bool check = !_tables.containsKey(tableName);
    assert(check ? true : throw "Table $tableName already exists");

    _tables.addAll({tableName: table});
  }

  static String _generateSql({String tableName}) {
    final Blueprint table = _tables[tableName];

    assert(table != null ? true : throw "The $tableName table does not exist");

    final StringBuffer sql = StringBuffer();

    sql.writeln('CREATE IF NOT EXISTS `$tableName` (');
    table.getColumns().forEach((column) => sql.writeln(column.getSQLColumn()));
    table.getColumns().forEach((column) {
      if (column.getSQLCommand().isNotEmpty)
        sql.writeln(column.getSQLCommand());
    });
    table.getCommands().forEach((command) {
      sql.writeln(command.getSQL());
    });
    sql.writeln(')');

    return sql.toString();
  }

  /// Generate single String from all tables
  static String _generateSqlFromAllTable() {
    final StringBuffer sqlString = StringBuffer();

    _tables.forEach((name, table) {
      sqlString.writeln(_generateSql(tableName: name));
    });
    _tables.clear();
    return sqlString.toString();
  }

  /// Generate SQL List from all tables
  static List<String> _generateSqlList() {
    final List<String> list = [];

    _tables.forEach((name, table) {
      list.add(_generateSql(tableName: name));
    });
    _tables.clear();
    return list;
  }

  static String _generateSQLDropTable({String tableName}) {
    final StringBuffer sql = StringBuffer();

    sql.writeln('DROP $tableName IF EXISTS');

    return sql.toString();
  }
}
