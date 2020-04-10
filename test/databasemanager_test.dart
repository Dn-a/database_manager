import 'package:database_manager/src/schema/blueprint.dart';
import 'package:database_manager/src/schema/schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('adds one to input values', ()
  {

    Schema.create(tableName: 'prova', callback: (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('title').unique();
      table.string('column1').unique().nullable();
    });

    Schema.table(tableName: 'prova', callback: (Blueprint table) {
      table.foreign(columns: ['title']).references(idList: ['id']).on(tableName: 'table').onDelete(action: 'restrict');
    });

    String sqlString =  Schema.getSQL(tableName: 'prova');
    print( sqlString );
  });

}
