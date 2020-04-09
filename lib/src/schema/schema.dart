
import 'package:flutter/foundation.dart';

import 'blueprint.dart';
import 'column_definition.dart';

typedef SchemaCallback = void Function(Blueprint table);

class Schema {

  static Map<String,String> _tablesSQL = {};

  static Map<String,String> getTablesSQL(){
    return _tablesSQL;
  }

  static create({ @required String tableName, @required SchemaCallback callback }){

      Blueprint table = Blueprint();
      callback(table);
      _addNewTable(name: tableName, columns: table.getColumns());

  }

  static table({@required String tableName}){

  }

  static dropIfExists(){

  }

  static void _addNewTable({String name, List<ColumnDefinition> columns}){
    bool check =  !_tablesSQL.containsKey(name);
    assert(check ? true : throw "Table $name already exists" );

//    if(check){
      final StringBuffer sql = StringBuffer('CREATE IF NOT EXISTS `$name` (\n');

      columns.forEach( (c) => sql.writeln(c.getSQL()) );
      sql.writeln(')');

      _tablesSQL.addAll({name:sql.toString()});
//    }
  }

}