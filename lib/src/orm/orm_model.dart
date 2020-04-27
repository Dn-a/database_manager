
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/connection.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';
import 'orm_builder.dart';


abstract class ORMModel extends ORMBuilder {

  final String databaseName = 'database';
  final int databaseVersion = 1;

  Database _db;

  Future<Connection> connection;

  ORMModel() {
    setConnection();
  }

  Future<void> setConnection() async {

    //_dbHelper = Connection();

    connection = await Connection().init(dbName: databaseName, version: databaseVersion,
      onCreate: (Database db, int version)  {
        if(this.migration().isEmpty) return;
        print("Database '$databaseName' created | version: $databaseVersion");
        Migrate migrate = Migrate(this.migration());
        List<String> sqlStringList = migrate.createList();
        try {
          db.transaction((tran) async =>
              sqlStringList.forEach((sql) async => await tran.execute(sql)));
        } catch (e) {
          print(e);
        }
      }
    ).then((dbHelper) {
      _db = dbHelper.database;

      return;

      print('\nDatabase Name: $databaseName');
      print('Table Name: $tableName \n\n');

      /*_dbHelper.raw(sql: 'PRAGMA table_info([users])').then((val) {
            List<dynamic> obj = [];
            val.forEach((a) {
              dynamic b = a['name'];
              obj.add(b);
              print(a);
            });
            //print(obj);
          });*/

//          _dbHelper.raw(sql: "insert into users (nome,cognome) values ('serena','rossi')");

     /* _dbHelper.raw(
          sql:
          "insert into table_1 (name,email,user_id) values ('mar','7email@email.com',1)");

      _dbHelper.raw(sql: 'select * from table_1').then((val) {
        val.forEach((a) {
          print(a);
        });
      });*/
    });
  }

  // ignore: missing_return
  List<Migration> migration() { return []; }
}
