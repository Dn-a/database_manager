
import 'package:flutter/cupertino.dart';

import 'column_definition.dart';

class Blueprint {

//  final String _tableName;
//  Blueprint({@required String tableName}): this._tableName = tableName;

  final List<ColumnDefinition> _columns = List();

  List<ColumnDefinition> getColumns(){
    return _columns;
  }


  ColumnDefinition _addColumn({String type, String name, Map<String,dynamic> parameters}){
    ColumnDefinition columnDefinition = ColumnDefinition(type: type, name: name, parameters: parameters);
    _columns.add(columnDefinition);
    return columnDefinition;
  }

  ColumnDefinition string(String name, {int length=255 }){
    //print(name);
    return _addColumn(type: 'VARCHAR', name: name, parameters: {'length': length} );
  }

  ColumnDefinition integer(String name, {int length=10 }){
    return _addColumn(type: 'INTEGER', name: name, parameters: {'length': length} );
  }

}
