# database_manager (Developer Preview)
[![pub package](https://img.shields.io/badge/pub-0.0.3+1-orange.svg)](https://pub.dartlang.org/packages/database_manager)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

Simple way to manage database. Version control and application's database schema. Simplify CRUD operations.

## Installing
Add this to your package's pubspec.yaml file:
```dart
dependencies:
  database_manager: "^0.0.3+1"
```
<a href="https://pub.dev/packages/sqflite" target="_blank">Sqlite</a>, 
[Path](https://pub.dev/packages/path) and 
[Path Provider](https://pub.dev/packages/path_provider) dependencies must be installed.

## Available features

- [x] Migration - version control and application's database schema
- [x] ORM - simplify CRUD operations

## Simple usage

### Migration

```dart
import 'package:database_manager/database_manager.dart';

class Table implements Migration {
  @override
  void up() {
    Schema.create('table', (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('name').nullable();
      table.string('email').unique();
      table.unsignedInteger('active').defaultValue(1);
    });    
  }
  @override
  void down() {
    Schema.dropIfExists('table');
  }
}
```

### Model

```dart
import 'package:database_manager/database_manager.dart';
import 'database/migration/table.dart';

class TableModel extends ORMModel {
  @override
  final String databaseName = 'test';
  @override
  final int databaseVersion = 1;

  @override
  List<Migration> migration() {
    return [Table1()];
  }
}
```

### Usage

```dart
import 'model/table_model.dart';

TableModel table = TableModel();

final List<Map<String, dynamic>> lst = [];
for (int i = 0; i < 1000; i++) lst.add({'name': 'marios', 'email': 'email$i@email.com'});

List ids = await table   
  .insert(lst, noResult: true, continueOnError: false)
  .catchError((e) => print(e));
   
print(ids);

table.get(['name','email']).then((r) => print(r) );

```

### Migration parameters
|PropName|Description|default value|
|:-------|:----------|:------------|
|`attribute`|*description*|value|


## Donate
It takes time to carry on this project. If you found it useful or learned something from the source code please consider the idea of donating 5, 20, 50 € or whatever you can to support the project.
- [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

## Issues
If you encounter problems, open an issue. Pull request are also welcome.
