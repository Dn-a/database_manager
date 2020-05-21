import 'package:database_manager/database_manager.dart';

class Table2 implements Migration {
  @override
  void up() {
    Schema.create('users', (Blueprint table) {
          table.integer('id').autoIncrement();
          table.string('nome');
          table.string('cognome');
        });

    Schema.table('users', (Blueprint table) {
      table.unique(columns: ['nome', 'cognome']);
    });
  }

  @override
  void down() {
    Schema.dropIfExists('users');
  }
}
