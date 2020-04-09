
import 'package:flutter/cupertino.dart';

import 'column_definition.dart';

class Blueprint {

//  final String _tableName;
//  Blueprint({@required String tableName}): this._tableName = tableName;
  static const int _defaultStringLength = 255;
  final List<ColumnDefinition> _columns = List();

  List<ColumnDefinition> getColumns(){
    return _columns;
  }

  ColumnDefinition _addColumn({String type, String name, Map<String,dynamic> parameters}){
    ColumnDefinition columnDefinition = ColumnDefinition(type: type, name: name, parameters: parameters);
    _columns.add(columnDefinition);
    return columnDefinition;
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

  /*ColumnDefinition unsignedInteger(String name, {bool autoincrement = false}){
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
  }*/

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
    return integer(name, autoincrement: true);
  }

  ColumnDefinition tinyIncrements(String name){
    return tinyInteger(name, autoincrement: true);
  }

  ColumnDefinition smallIncrements(String name){
    return smallInteger(name, autoincrement: true);
  }

  ColumnDefinition mediumIncrements(String name){
    return mediumInteger(name, autoincrement: true);
  }

  ColumnDefinition bigIncrements(String name){
    return bigInteger(name, autoincrement: true);
  }





}
