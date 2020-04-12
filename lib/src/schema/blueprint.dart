
import 'package:flutter/cupertino.dart';

import 'column_definition.dart';
import 'package:database_manager/src/schema/sql_command.dart';

class Blueprint {

  static const int _defaultStringLength = 255;
  final List<ColumnDefinition> _columns = List();
  final List<SQLCommand> _commands = [];

  List<ColumnDefinition> getColumns(){
    return _columns;
  }

  List<SQLCommand> getCommands(){
    return _commands;
  }

  ColumnDefinition _addColumn({String type, String name, Map<String,dynamic> parameters}){
    ColumnDefinition columnDefinition = ColumnDefinition(type: type, name: name, parameters: parameters);
    _columns.add(columnDefinition);
    return columnDefinition;
  }

  SQLCommand _addCommand({String name, Map<String,dynamic> parameters}){
    SQLCommand sqlCommand = SQLCommand(name: name, parameters: parameters);
    _commands.add(sqlCommand);
    return sqlCommand;
  }

  SQLCommand _indexCommand({String type, List<String> columns, String indexName }){
    return _addCommand(name: type, parameters: { 'indexName':indexName, 'columns': columns });
  }

  ColumnDefinition char(String name, {int length = _defaultStringLength }){
    //print(name);
    return _addColumn(type: 'CHARACTER', name: name, parameters: {'length': length} );
  }

  ColumnDefinition string(String name, {int length = _defaultStringLength }){
    //print(name);
    return _addColumn(type: 'VARCHAR', name: name, parameters: {'length': length} );
  }

  ColumnDefinition text(String name){
    //print(name);
    return _addColumn(type: 'TEXT', name: name );
  }

  ColumnDefinition integer(String name, {bool autoincrement = false, bool unsigned = false }){
    return _addColumn(type: 'INTEGER', name: name, parameters: {'autoincrement': autoincrement, 'unsigned': unsigned} );
  }

  ColumnDefinition tinyInteger(String name, {bool autoincrement = false, bool unsigned = false }){
    return _addColumn(type: 'TINYINT', name: name, parameters: {'autoincrement': autoincrement, 'unsigned': unsigned} );
  }

  ColumnDefinition smallInteger(String name, {bool autoincrement = false, bool unsigned = false }){
    return _addColumn(type: 'SMALLINT', name: name, parameters: {'autoincrement': autoincrement, 'unsigned': unsigned} );
  }

  ColumnDefinition mediumInteger(String name, {bool autoincrement = false, bool unsigned = false }){
    return _addColumn(type: 'MEDIUMINT', name: name, parameters: {'autoincrement': autoincrement, 'unsigned': unsigned} );
  }

  ColumnDefinition bigInteger(String name, {bool autoincrement = false, bool unsigned = false }){
    return _addColumn(type: 'BIGINT', name: name, parameters: {'autoincrement': autoincrement, 'unsigned': unsigned} );
  }

  ColumnDefinition unsignedInteger(String name, {bool autoincrement = false}){
    return integer(name, autoincrement: autoincrement, unsigned: true );
  }

  ColumnDefinition unsignedTinyInteger(String name, {bool autoincrement = false}){
    return tinyInteger(name, autoincrement: autoincrement, unsigned: true );
  }

  ColumnDefinition unsignedSmallInteger(String name, {bool autoincrement = false}){
    return smallInteger(name, autoincrement: autoincrement, unsigned: true );
  }

  ColumnDefinition unsignedMediumInteger(String name, {bool autoincrement = false}){
    return mediumInteger(name, autoincrement: autoincrement, unsigned: true );
  }

  ColumnDefinition unsignedBigInteger(String name, {bool autoincrement = false}){
    return bigInteger(name, autoincrement: autoincrement, unsigned: true );
  }

  ColumnDefinition float(String name){
    return _addColumn(type: 'FLOAT', name: name,
        //parameters: {'total': total, 'places': places}
    );
  }

  ColumnDefinition double(String name){
    return _addColumn(type: 'DOUBLE', name: name );
  }

  ColumnDefinition real(String name){
    return _addColumn(type: 'REAL', name: name );
  }

  ColumnDefinition decimal(String name){
    return _addColumn(type: 'DECIMAL', name: name );
  }

  ColumnDefinition blob(String name){
    return _addColumn(type: 'BLOB', name: name );
  }

  ColumnDefinition date(String name){
    return _addColumn(type: 'DATE', name: name );
  }

  ColumnDefinition timestamp(String name){
    return _addColumn(type: 'TIMESTAMP', name: name );
  }

  ColumnDefinition dateTime(String name){
    return _addColumn(type: 'DATETIME', name: name );
  }

  ColumnDefinition increments(String name){
    return unsignedInteger(name, autoincrement: true).primary();
  }

  ColumnDefinition tinyIncrements(String name){
    return unsignedTinyInteger(name, autoincrement: true);
  }

  ColumnDefinition smallIncrements(String name){
    return unsignedSmallInteger(name, autoincrement: true);
  }

  ColumnDefinition mediumIncrements(String name){
    return unsignedMediumInteger(name, autoincrement: true);
  }

  ColumnDefinition bigIncrements(String name){
    return unsignedBigInteger(name, autoincrement: true);
  }

  SQLCommand primary( {@required List<String> columns, String indexName} ){
    return _indexCommand(type: 'PRIMARY', columns: columns, indexName: indexName );
  }

  SQLCommand unique( {@required List<String> columns, String indexName} ){
    return _indexCommand(type: 'UNIQUE', columns: columns, indexName: indexName );
  }

  SQLCommand index( {@required List<String> columns, String indexName} ){
    return _indexCommand(type: 'INDEX', columns: columns, indexName: indexName );
  }

  SQLCommand foreign( {@required List<String> columns, String indexName} ){
    return _indexCommand(type: 'FOREIGN', columns: columns, indexName: indexName );
  }

  SQLCommand drop( {@required String tableName} ){
    return _addCommand(name: 'DROP', parameters: {'tableName' : tableName} );
  }
}
