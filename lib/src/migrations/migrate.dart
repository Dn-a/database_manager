import 'migration_interface.dart';
import '../schema/schema.dart';

class Migrate {
  final List<Migration> _migration = [];

  /// Dependency Injection
  Migrate(List<Migration> migration) {
    _migration.addAll(migration);
  }

  /// List of SQL String from all tables
  List<String> create() {
    _migration.forEach((m) => m.up());
    return Schema.getSQLList();
  }

  /// List of Drop SQL String from all tables
  List<String> drop() {
    _migration.forEach((m) => m.down());
    return Schema.getAllDropSQL();
  }
}
