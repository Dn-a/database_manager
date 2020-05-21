import 'package:database_manager/database_manager.dart';

class Table1 implements Migration {
  @override
  void up() {
    Schema.create('table_1', (Blueprint table) {
          table.integer('id').autoIncrement();
          table.string('name');
          table.string('email').unique();
          table.string('cell').nullable();
          table.integer('user_id').defaultValue(1);
        });

    Schema.table('table_1', (Blueprint table) {
      table.check(" name <> 'mark' ").check("email != 'email@email.com'");
      table
          .foreign(columns: ['user_id'])
          .references(idList: ['id'])
          .on(tableName: 'users')
          .onDeleteCascade();
    });
  }

  @override
  void down() {
    Schema.dropIfExists('table_1');
  }
}
