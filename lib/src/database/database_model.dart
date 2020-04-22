import 'package:database_manager/database_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseModel {

  String tableName;
  String databaseName = 'database';

  Database _db;
  DatabaseHelper _dbHelper;

  DatabaseModel() {
    this._init();
  }

  void _init(){

    DatabaseHelper().init(dbName: databaseName).then((dbHelper) {
      _dbHelper = dbHelper;
      _db = dbHelper.database;

      final dynamic migration = this.migrate();

      if(migration!= null && migration.isNotEmpty){
        Migrate migrate = Migrate(migration);
        List<String> sqlStringList = migrate.createList();

        _dbHelper.migrate(sqlMigrationsList: sqlStringList);

        print('\nDatabase Name: $databaseName');
        print('Table Name: $tableName \n\n');
        print(sqlStringList);

        //_dbHelper.dropDatabase();
        _dbHelper.raw(sql: 'PRAGMA table_info([table_1])').then((val) {
          val.forEach((a) {
            print(a);
          });
        });
      }

    });
  }

  // ignore: missing_return
  List<Migration> migrate(){}

}
