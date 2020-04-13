import 'package:database_manager/database_manager.dart';
import 'package:example/database/connect.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Database', (WidgetTester tester) async {
    Migrate migrate = Migrate([
      Table1(),
    ]);

    String sqlString = migrate.create();

    //print (sqlString);

    Connect db = await Connect().init(dbName: 'prova');

    db.raw(sql: 'DESC prova_1').then((val) {
      val.forEach((a) {
        print(a);
      });
    });
  });
}
