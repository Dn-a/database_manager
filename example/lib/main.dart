import 'package:flutter/material.dart';

import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';
import 'package:sqflite/sqflite.dart';

import 'model/table1_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Migration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("migrate"),
              onPressed: _migrate,
            ),
            RaisedButton(
              child: Text("drop database"),
              onPressed: () {
                Connection con = Connection();
                con.init(dbName: 'prova');
                con.dropDatabase();
              },
            ),
            /*Text(
              '${_migrate()}',
              //style: Theme.of(context).textTheme.display1,
            ),*/
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _migrate() async {
    Table1Model table = Table1Model();

    /*List<int> ids = await table.insert([
      { 'name' : 'franco', 'email' : 'francos2@email.com' },
      { 'name' : 'carlos', 'email' : 'carloa2@email.com' },
      { 'name' : 'maria', 'email' : 'mariaDB2@email.com' }
    ]);
    print(ids);*/

    table
        //.where(column: 'id', value: 2)
        //.where(column: 'name', operator: 'like', value: '%ar')
        //.orWhere(column: 'name', operator: 'like', value: 'm%')
        .whereNotIn(column: 'id', values: ['2', '3', '4'])
        .orWhere(column: 'id', value: 1)
        //.orWhere(column: 'email', operator: 'like', value: '8email%')
        .get(['*'])
        .then((val) {
          val.forEach((a) => print(a));
        })
        .catchError((e) => print(e));

    return;
  }
}
