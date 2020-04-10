
import 'package:flutter/foundation.dart';

import 'blueprint.dart';

typedef SchemaCallback = void Function(Blueprint table);

class Schema {

  static Map<String,Blueprint> _tables = {};

  /// Returns SQL from a single table
  static String getSQL({@required String tableName}){
    assert(_tables[tableName]!=null ? true : throw "The $tableName table does not exist");

    return _generateSQLTable(tableName: tableName);
  }

  static create({ @required String tableName, @required SchemaCallback callback }){

    Blueprint table = Blueprint();
    callback(table);

    _addTable(tableName: tableName, table: table );

  }

  static table({@required String tableName, @required SchemaCallback callback}){
    assert( _tables[tableName]!=null ? true : throw "The $tableName table does not exist" );

    Blueprint table = _tables[tableName];
    callback(table);
  }

  static dropIfExists({String tableName}){

  }

  static void _addTable({String tableName, Blueprint table}){
    final bool check =  !_tables.containsKey(tableName);
    assert(check ? true : throw "Table $tableName already exists" );

    _tables.addAll(
        {
          tableName : table
        }
    );
  }

  static String _generateSQLTable({ String tableName }){

    final Blueprint table = _tables[tableName];

    final StringBuffer sql = StringBuffer();

    sql.writeln('CREATE IF NOT EXISTS `$tableName` (');
    table.getColumns().forEach( (column) =>
        sql.writeln( column.getSQLColumn() )
    );
    table.getColumns().forEach( (column) {
      if(column.getSQLCommand().isNotEmpty)
        sql.writeln( column.getSQLCommand() );
    });
    table.getCommands().forEach( (command) {
      sql.writeln( command.getSQL() );
    });
    sql.writeln(')');

    return sql.toString();
  }

}