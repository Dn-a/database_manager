# database_manager
[![pub package](https://img.shields.io/badge/pub-0.0.1-orange.svg)](https://pub.dartlang.org/packages/database_manager)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

Simple way to manage database.

## Installing
Add this to your package's pubspec.yaml file:
```dart
dependencies:
  database_manager: "^0.0.1"
```

# Available features

- [x] Migration - version control and application's database schema
- [ ] ORM(work in progress) - simplify CRUD operations

## Simple usage
```dart
import 'package:database_manager/database_manager.dart';

class Table1 implements Migration {

  @override
  void up() {
    Schema.create(tableName: 'table_1', callback: (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('name');
      table.string('email').unique();
    });
  }

  @override
  void down() {
    Schema.dropIfExists(tableName: 'table_1');
  }

}

class Todo {

  void test(){

    Migrate migrate = Migrate([
      Table1(),
    ]);

    String sqlString = migrate.create();

  }
}
```

### Migration parameters
|PropName|Description|default value|
|:-------|:----------|:------------|
|`attribute`|*description*|value|


## Donate
If you found this project helpful or you learned something from the source code and want to thank me: 
- [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

## Issues
If you encounter problems, open an issue. Pull request are also welcome.
