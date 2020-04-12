import 'package:database_manager/database_manager.dart';

class Table2 implements Migration {
  @override
  void up() {
    Schema.create(
        tableName: 'table_2',
        callback: (Blueprint table) {
          table.integer('id').autoIncrement();
          table.string('title').unique();
          table.string('column1').unique().nullable();
          table.integer('user_id').defaultValue(value: '1');
        });

    Schema.table(
        tableName: 'table_2',
        callback: (Blueprint table) {
          table.foreign(columns: ['user_id']).references(idList: ['id']).on(
              tableName: 'user');
        });
  }

  @override
  void down() {
    Schema.dropIfExists(tableName: 'table_2');
  }
}
