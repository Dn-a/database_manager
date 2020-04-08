
import 'package:flutter/foundation.dart';

import 'blueprint.dart';
import 'column_definition.dart';

typedef SchemaCallback = void Function(Blueprint table);

class Schema {

  static Map<String,List<ColumnDefinition>> _tables = {};

  static Map<String,List<ColumnDefinition>> getTables(){
    return _tables;
  }

  static create({ @required String tableName, @required SchemaCallback callback }){

      Blueprint table = Blueprint();
      callback(table);

      _addNewTable(name: tableName, columns: table.getColumns());
  }

  static table(){

  }

  static dropIfExists(){

  }

  static void _addNewTable({String name, List<ColumnDefinition> columns}){
    bool check =  !_tables.containsKey(name);
    assert(check ? true : throw "Table $name already exists" );

    if(check)
      _tables.addAll({name:columns});
  }

}