import 'package:flutter/material.dart';

import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';
import 'package:sqflite/sqflite.dart';

import 'model/table1_model.dart';
import 'model/table2_model.dart';

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

  void _dbTest() async {
    Connection con = Connection();
    await con.init(
        dbName: 'db',
        onCreate: (db, v) {
          db.execute("CREATE TABLE IF NOT EXISTS `table` ("
              "`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
              "`name` VARCHAR(255) NOT NULL,"
              "`email` VARCHAR(255) NOT NULL,"
              "`cell` VARCHAR(255) DEFAULT NULL,"
              "UNIQUE (`email`)"
              ");");
        });
    Database db = con.database;
    await db.delete('table');
    await db.transaction((db) async {
      Batch btc = db.batch();
      for (int i = 0; i < 10000; i++) {
        //btc.execute("INSERT INTO 'table'(name,email) VALUES(?,?)",['mario','email$i@email.com']);
        btc.insert("table", {'name': 'mario', 'email': 'email$i@email.com'});
      }
      return await btc.commit(noResult: true);
    });

    db.query('table', where: 'exists (select * from "table" tb where tb.id = id and name =?)',whereArgs: ['mario']).then((res) => print(res));
  }

  Future<void> _migrate() async {
    //_dbTest();return;

    Table1Model table1 = Table1Model();
    Table2Model table2 = Table2Model();

    //table2.delete();
    //table2.insert([{'nome':'mario','cognome':'rossi'}]);

    table1.delete();

    table1.where(nested: (query) => query.where(column: 'aa', value: 'suca'));

    List<Map<String, dynamic>> lst = [];
    //lst.add({'name': 'marios', 'email': 'marios100@email.com'});
    //lst.add({'name': 'marios', 'email': 'marios200@email.com'});
    for (int i = 0; i < 1000; i++)
      lst.add({'name': 'marios', 'email': 'marios$i@email.com'});

    List ids = await table1.insert(lst, noResult: true, continueOnError: false).catchError((e) => print(e));
    //print(ids);
    //table1.whereIn(column: 'id', values: ['1','2']).update({'name' :'mario'});
    int cnt = await table1.count();
    print(cnt);

    //table1.whereIn('email', values: ['marios2@email.com','marios3@email.com','marios20000@email.com']);
    //table1.limit(2);
    //table1.get();
    //table1.insert([{'name': 'marios', 'email': 'marios20000@email.com'}]);
    //int cnt2 = await table1.count();
    //table1.get(['name','email']).then((r) => print(r) );

    /*int cnt = await table1.where(column: 'name', value: 'marios').whereIn(
        column: 'id',
        values: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8'
        ]).update({'name': 'carlitos'});
    print(cnt);*/

    /*table1
        //.orWhere(column: 'name', operator: 'like', value: 'm%')
        //.whereNotIn(column: 'id', values: ['2', '3', '4'])
        //.select(['min(id) min','avg(id) avg','max(id) max'])
        //.having(column: 'cnt', value: 2)
        .having(column: 'name', value: 'carlitos')
        .groupBy(['name','email'])
        //.limit(5).offset(1)
        //.distinct()
        //.get()
        //.where(column: 'id',value: 1)
        .get(['id','name','email'])
        .then((val) {
          val.forEach((a) => print(a));
        })
        .catchError((e) => print(e));*/
    //table1.delete();
    //table1.whereIn(column: 'id', values: ['1','2']).update({'name' :'mario'});
    //int cnt = await table1.count();
    //print(cnt);
    /*table1.where(column: 'name', value: 'mario').get(['id','name']).then((res){
      res.forEach((v) => print(v) );
    });*/
    /*table1
        .where(column: 'name', value: 'carlitos')
        .get(['id', 'name']).then((list) => list.forEach((val) => print(val)));
    print('');
    table1
        .select(['id', 'name'])
        .where(column: 'name', value: 'carlitos')
        .min('id', alias: 'min')
        .then((val) => print(val));
    table1
        .select(['id', 'name'])
        .where(column: 'name', value: 'carlitos')
        .avg('id', alias: 'avg')
        .then((val) => print(val));
    table1
        .select(['id', 'name'])
        .where(column: 'name', value: 'carlitos')
        .max('id', alias: 'max')
        .then((val) => print(val));*/
  }
}
