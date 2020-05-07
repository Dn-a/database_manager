
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/connection.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';
import 'orm_builder.dart';

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

          final List migration = this.migrationOnCreate();
          if (migration.isEmpty) return;

          this._migrate(db: db, migration: migration);
        });

    Database database = connection.database;

    final List migration = this.migration();
    if (migration.isNotEmpty) await this._migrate(db: database, migration: migration);

    return database;
  }

  /// migration is performed only during the database creation phase
  List<Migration> migrationOnCreate() {
    return [];
  }

  /// migration is performed each time the model is invoked
  List<Migration> migration() {
    return [];
  }

  Future<void> _migrate({Database db, List<Migration> migration}) async {

    Migrate migrate = Migrate(migration);
    List<String> sqlStringList = migrate.createList();
    await db
        .transaction((tran) async =>
        sqlStringList.forEach((sql) async => await tran.execute(sql)))
        .catchError((error) => throw('On transaction error: $error') );
  }
}
