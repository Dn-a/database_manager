import 'package:database_manager/src/schema/blueprint.dart';
import 'package:database_manager/src/schema/schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('adds one to input values', ()
  {
    /*Map<String,List<List>> _tables = {'suca':[]};
    String name = 'suca';
    assert(!_tables.containsKey(name) ? true : throw "Table ${name} already exists" ); return;*/

    Schema.create(tableName: 'prova', callback: (Blueprint table) {
      table.string('title').unique();
      table.string('column').unique().nullable();
      table.integer('suca').autoIncrement();
    });

    Map<String,String> aa =  Schema.getTablesSQL();
    print( aa['prova'] );
  });

}
