import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Database', (WidgetTester tester) async {
    Migrate migrate = Migrate([
      Table1(),
    ]);

    //String sqlString = migrate.;

    //print (sqlString);

    DatabaseHelper db = await DatabaseHelper().init(dbName: 'prova');

    db.raw(sql: 'DESC prova_1').then((val) {
      val.forEach((a) {
        print(a);
      });
    });
  });
}
