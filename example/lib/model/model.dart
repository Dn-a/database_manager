import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';
import 'package:flutter/foundation.dart';

class Model extends ORMModel {

  @override
  final String databaseName = 'prova';
  @override
  final int databaseVersion = 1;

  var _a = 1;

  @override
  List<Migration> migration() {
    return [Table1(), Table2()];
  }
}
