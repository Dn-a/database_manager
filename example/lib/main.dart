import 'package:flutter/material.dart';

import 'package:database_manager/database_manager.dart';
import 'package:example/database/migration/table1.dart';
import 'package:example/database/migration/table2.dart';

import 'database/connect.dart';

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
              child: Text("test sql"),
              onPressed: _migrate,
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

    Connect db = await Connect().init(dbName: 'prova');

    Migrate migrate = Migrate([Table1(), Table2()]);

    List<String> sqlStringList = migrate.createList();

    //print(sqlStringList);

    //db.dropDatabase();
    db.migrate(sqlMigrationsList: sqlStringList);

    /*db.raw(sql: 'PRAGMA table_info([table_1])').then((val){
        val.forEach((a){
          print(a);
        });
      });*/

    //db.raw(sql: "insert into users (nome,cognome) values ('mario','rossi')");

    db.raw(
        sql:
        "insert into table_1 (name,email,user_id) values ('mario','sesmsail@email.com',1)");

    db.raw(sql: 'select * from table_1').then((val) {
      val.forEach((a) {
        print(a);
      });
    });
  }
}
