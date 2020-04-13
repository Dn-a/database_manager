import 'package:database_manager/database_manager.dart';

class Table1 implements Migration {
  @override
  void up() {
    Schema.create(
        tableName: 'table_1',
        callback: (Blueprint table) {
          table.integer('id').autoIncrement();
          table.string('name');
          table.string('email').unique();
          table.string('cell').nullable();
          table.integer('user_id').defaultValue(value: 1);
        });

    Schema.table(
        tableName: 'table_1',
        callback: (Blueprint table) {
          table.foreign(columns: ['user_id']).references(idList: ['id']).on(
              tableName: 'users');
        });
  }

  @override
  void down() {
    Schema.dropIfExists(tableName: 'table_1');
  }
}
