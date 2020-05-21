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

## Available features

- [x] Migration - version control and application's database schema
- [ ] ORM(work in progress) - simplify CRUD operations

## Simple usage
```dart
import 'package:database_manager/database_manager.dart';

class Table1 implements Migration {
  @override
  void up() {
    Schema.create('table_1', (Blueprint table) {
      table.integer('id').autoIncrement();
      table.string('name');
      table.string('email').unique();
      table.string('cell').nullable();
      table.unsignedInteger('user_id').defaultValue(1);
    });

    Schema.table('table_1', (Blueprint table){
      table.check(" name<>'mark' ")
            .andCheck("email = 'aa@bb.com'");
      table.foreign(columns: ['user_id']).references(idList: ['id']).on(
            tableName: 'users').onDelete(action: 'cascade');
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

    String sqlString = migrate.createList();

  }
}
```
## Output 
```roomsql
CREATE TABLE IF NOT EXISTS `table_1` (
`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
`name` VARCHAR(255) NOT NULL,
`email` VARCHAR(255) NOT NULL,
`cell` VARCHAR(255) DEFAULT NULL,
`user_id` INTEGER UNSIGNED NOT NULL DEFAULT '1',
UNIQUE (`email`),
CHECK (name<>'mark' AND email = 'aa@bb.com'),
FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);
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
