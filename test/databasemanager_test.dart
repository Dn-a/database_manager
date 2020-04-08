import 'package:databasemanager/src/schema/blueprint.dart';
import 'package:databasemanager/src/schema/schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('adds one to input values', ()
  {
    /*Map<String,List<List>> _tables = {'suca':[]};
    String name = 'suca';
    assert(!_tables.containsKey(name) ? true : throw "Table ${name} already exists" ); return;*/

    Schema.create(tableName: 'prova', callback: (Blueprint table) {
      table.string('title').unique();
      table.string('column').unique();
      table.integer('suca').unsigned()
      .autoIncrement();
      //.defaultValue(value: 1);
      /*print(
          table.integer('suca').unsigned()
          //.nullable()
          //.defaultValue(value: 1)
          .getSQL()
      );*/
    });

    Map<String,List> aa =  Schema.getTables();
    aa['prova'].forEach( (f) => print(f.getSQL()));
  });

  /*test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });*/
}
