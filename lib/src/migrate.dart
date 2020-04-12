
import 'package:database_manager/src/migration_interface.dart';
import 'package:database_manager/src/schema/schema.dart';

class Migrate {

  final List<Migration> _migration = [];

  /// Dependency Injection
  Migrate (List<Migration> migration){
    _migration.addAll(migration);
  }

  String create(){
    _migration.forEach( (m) => m.up() );
    return Schema.getSQLAllTable();
  }

  List<String> createList(){
    _migration.forEach( (m) => m.up() );
    return Schema.getSQLList();
  }

  List<String> drop(){
    _migration.forEach( (m) => m.down() );
    return Schema.getAllDropSQL();
  }

}