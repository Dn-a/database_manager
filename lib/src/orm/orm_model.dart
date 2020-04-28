
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/connection.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';
import 'orm_builder.dart';


abstract class ORMModel extends ORMBuilder {

  final String databaseName = 'database';
  final int databaseVersion = 1;


  ORMModel() {
    //setConnection();
  }

  @override
  Future<Connection> setConnection({Connection connection}) async {

    Connection conn = Connection();

    if(connection != null)
      conn = connection;

    await conn.init(dbName: databaseName, version: databaseVersion,
        onCreate: (Database db, int version)  {

          if(this.migrationOnCreate().isEmpty) return;

          print("Database '$databaseName' created | version: $databaseVersion");

          this._migrate(db: db, migration: this.migrationOnCreate() );

        }
    );

    Database db = conn.database;

    if(this.migration().isNotEmpty)
      this._migrate(db: db, migration: this.migration() );

    //conn.raw(sql: "insert into users (nome,cognome) values ('serena','rossisa')");
    //conn.raw( sql: "insert into table_1 (name,email,user_id) values ('mar','1email@email.com',2)");

    //print('\nDatabase Name: $databaseName');
    //print('Table Name: $tableName \n\n');

    /*_dbHelper.raw(sql: 'PRAGMA table_info([users])').then((val) {
            List<dynamic> obj = [];
            val.forEach((a) {
              dynamic b = a['name'];
              obj.add(b);
              print(a);
            });
            //print(obj);
          });*/

    return conn;
  }

  /// migration is performed only during the database creation phase
  List<Migration> migrationOnCreate() { return []; }

  /// migration is performed each time the model is invoked
  List<Migration> migration() { return []; }

  void _migrate({ Database db, List<Migration> migration }){

    Migrate migrate = Migrate(migration);
    List<String> sqlStringList = migrate.createList();

    try {
      db.transaction((tran) async =>
          sqlStringList.forEach((sql) async => await tran.execute(sql)));
    } catch (e) {
      print(e);
    }
  }

}
