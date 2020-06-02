
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'builder/orm_builder.dart';
import '../database/connection.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';


abstract class ORMModel extends ORMBuilder {
  @protected
  final String databaseName = 'database';
  @protected
  final int databaseVersion = 1;

  @override
  Future<Database> setConnection({Database conn}) async {
    Connection connection = conn == null ? Connection() : conn;

    await connection.init(
        dbName: databaseName,
        version: databaseVersion,
        onCreate: (Database db, int version) {
          print("Database '$databaseName' created | version: $databaseVersion");
          this._migrate(db: db);
        },
        onUpgrade: (Database db, int old, int next) {
          if (next > old) this._migrate(db: db);
        });

    Database database = connection.database;

    return database;
  }

  /// migration is performed only during the database creation phase
  List<Migration> migration() {
    return [];
  }

  Future<void> _migrate({Database db}) async {
    final List migration = this.migration();
    final Migrate migrate = Migrate(migration);
    List<String> sqlStringList = migrate.create();
    await db
        .transaction((tran) async =>
            sqlStringList.forEach((sql) async => await tran.execute(sql)))
        .catchError((error) => throw ('On transaction error: $error'));
  }
}
