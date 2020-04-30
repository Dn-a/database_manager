import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';

class Model extends ORMModel {
  @override
  final String databaseName = 'prova';
  @override
  final int databaseVersion = 1;

  @override
  List<Migration> migrationOnCreate() {
    return [Table1(), Table2()];
  }
}
