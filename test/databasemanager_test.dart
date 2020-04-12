import 'package:database_manager/src/migrate.dart';
import 'package:database_manager/src/migration_interface.dart';
import 'package:database_manager/src/schema/blueprint.dart';
import 'package:database_manager/src/schema/schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('test migrate', (){

    Migrate migrate = Migrate([
      Table1(),
      //Table2(),
    ]);

    print(migrate.create());

    //print(migrate.drop());

  });
}

class Table1 implements Migration {

  @override
  void up() {

    Schema.create(tableName: 'table_1', callback: (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('name').unique();
      table.string('email').unique().nullable();
      table.integer('user_id').defaultValue(value: '1');
    });

    Schema.table(tableName: 'table_1', callback: (Blueprint table){
      table.foreign(columns: ['user_id']).references(idList: ['id']).on(tableName: 'user');
    });

  }

  @override
  void down() {
    Schema.dropIfExists(tableName: 'table_1');
  }

}

class Table2 implements Migration {

  @override
  void up() {

    Schema.create(tableName: 'table_2', callback: (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('title').unique();
      table.string('column1').unique().nullable();
      table.integer('user_id').defaultValue(value: '1');
    });

    Schema.table(tableName: 'table_2', callback: (Blueprint table){
      table.foreign(columns: ['user_id']).references(idList: ['id']).on(tableName: 'user');
    });

  }

  @override
  void down() {
    Schema.dropIfExists(tableName: 'table_2');
  }

}
