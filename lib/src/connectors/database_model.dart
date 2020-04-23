import 'package:sqflite/sqflite.dart';
import 'databse_helper.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';
import '../orm/orm_builder.dart';

@proxy
abstract class DatabaseModel extends ORMBuilder {
  final String tableName = '';
  final String databaseName = 'database';

  Database _db;
  DatabaseHelper _dbHelper;

  DatabaseModel() {
    this._init();
  }

  void _init() {
    DatabaseHelper().init(dbName: databaseName).then((dbHelper) {
      _dbHelper = dbHelper;
      _db = dbHelper.database;

      final dynamic migration = this.migrate();

      if (migration != null && migration.isNotEmpty) {
        Migrate migrate = Migrate(migration);
        List<String> sqlStringList = migrate.createList();

        _dbHelper.migrate(sqlMigrationsList: sqlStringList);

        // TEST
        /*print('\nDatabase Name: $databaseName');
          print('Table Name: $tableName \n\n');
          print(sqlStringList);*/

//          _dbHelper.dropDatabase();

        /*_dbHelper.raw(sql: 'PRAGMA table_info([table_1])').then((val) {
            List<dynamic> obj = [];
            val.forEach((a) {
              dynamic b = a['name'];
              obj.add(b);
              print(a);
            });
            //print(obj);
          });*/

//          _dbHelper.raw(sql: "insert into users (nome,cognome) values ('serena','rossi')");

        _dbHelper.raw(
            sql:
                "insert into table_1 (name,email,user_id) values ('mar','7email@email.com',1)");

        _dbHelper.raw(sql: 'select * from table_1').then((val) {
          val.forEach((a) {
            print(a);
          });
        });

        //END TEST

      }
    });
  }

  // ignore: missing_return
  List<Migration> migrate() {}
}
