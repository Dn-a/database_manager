import 'package:sqflite/sqflite.dart';
import '../database/connection.dart';
import '../migrations/migrate.dart';
import '../migrations/migration_interface.dart';
import 'orm_builder.dart';

abstract class ORMModel extends ORMBuilder {
  final String databaseName = 'database';
  final int databaseVersion = 1;

  @override
  Future<Connection> setConnection() async {
    Connection connection = Connection();

    await connection.init(
        dbName: databaseName,
        version: databaseVersion,
        onCreate: (Database db, int version) {
          final List migration = this.migrationOnCreate();
          if (migration.isEmpty) return;

          print("Database '$databaseName' created | version: $databaseVersion");

          this._migrate(db: db, migration: migration);
        });

    Database db = connection.database;

    final List migration = this.migration();
    if (migration.isNotEmpty) this._migrate(db: db, migration: migration);

    /*_dbHelper.raw(sql: 'PRAGMA table_info([users])').then((val) {
            List<dynamic> obj = [];
            val.forEach((a) {
              dynamic b = a['name'];
              obj.add(b);
              print(a);
            });
            //print(obj);
          });*/

    return connection;
  }

  /// migration is performed only during the database creation phase
  List<Migration> migrationOnCreate() {
    return [];
  }

  /// migration is performed each time the model is invoked
  List<Migration> migration() {
    return [];
  }

  void _migrate({Database db, List<Migration> migration}) {
    Migrate migrate = Migrate(migration);
    List<String> sqlStringList = migrate.createList();

    db
        .transaction((tran) async =>
            sqlStringList.forEach((sql) async => await tran.execute(sql)))
        .catchError((error) => print('On migrate: $error'));
  }
}
