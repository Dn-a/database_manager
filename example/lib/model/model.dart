import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';

class Model extends DatabaseModel {
  @override
  final String databaseName = 'prova';

  @override
  List<Migration> migrate() {
    return [Table1(), Table2()];
  }
}
