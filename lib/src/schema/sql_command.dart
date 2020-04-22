import 'package:flutter/foundation.dart';

class SQLCommand {
  final String _name;
  final Map<String, dynamic> _parameters;

  SQLCommand(
      {@required String name,
      Map<String, dynamic> parameters = const <String, dynamic>{}})
      : this._name = name,
        this._parameters = parameters;

  String _references = '';

  String _on = '';
  String _onDelete = '';
  String _onUpdate = '';

  List<String> _andCheck = [];
  List<String> _orCheck = [];

  String getSQL() {
    switch (_name) {
      case 'PRIMARY':
        return _primaryGenerator();
        break;
      case 'INDEX':
        return _indexGenerator();
        break;
      case 'UNIQUE':
        return _uniqueGenerator();
        break;
      case 'FOREIGN':
        return _foreignGenerator();
        break;
      case 'DROP':
        return _dropGenerator();
        break;
      case 'CHECK':
        return _checkGenerator();
        break;
      default:
        return '';
    }
  }

  String _primaryGenerator() {
    StringBuffer str = StringBuffer();

    str.write('PRIMARY KEY');
    str.write(_argsGeneratorFromList(_parameters['columns']));

    return str.toString();
  }

  String _uniqueGenerator() {
    StringBuffer str = StringBuffer();

    str.write('UNIQUE ');
    str.write(_argsGeneratorFromList(_parameters['columns']));

    return str.toString();
  }

  String _indexGenerator() {
    StringBuffer str = StringBuffer();

    /// da rivedere
    str.write('INDEX ');
    str.write(_argsGeneratorFromList(_parameters['columns']));

    return str.toString();
  }

  String _checkGenerator() {
    String expression =
        _parameters['expression'] != null ? _parameters['expression'] : '';

    StringBuffer str = StringBuffer();

    str.write('CHECK ');
    str.write('(');
    str.write(expression.trim());
    _andCheck.forEach((ck) => str.write(' AND ${ck.trim()}'));
    _orCheck.forEach((ck) => str.write(' OR ${ck.trim()}'));
    str.write(')');

    return str.toString();
  }

  SQLCommand andCheck(String expression) {
    _andCheck.add(expression);
    return this;
  }

  SQLCommand orCheck({@required String expression}) {
    _orCheck.add(expression);
    return this;
  }

  String _foreignGenerator() {
    StringBuffer str = StringBuffer();

    str.write('FOREIGN KEY');
    str.write(_argsGeneratorFromList(_parameters['columns']));
    str.write(' REFERENCES ');
    str.write('`$_on`');
    str.write('$_references');
    if (_onDelete.isNotEmpty) str.write(' $_onDelete');
    if (_onUpdate.isNotEmpty) str.write(' $_onUpdate');

    return str.toString();
  }

  String _dropGenerator() {
    var tableName =
        _parameters['tableName'] != null ? _parameters['tableName'] : '';
    StringBuffer str = StringBuffer();

    str.write('DROP $tableName IF EXISTS');

    return str.toString();
  }

  SQLCommand references({@required List<String> idList}) {
    _references = _argsGeneratorFromList(idList);
    return this;
  }

  SQLCommand on({@required String tableName}) {
    _on = tableName;
    return this;
  }

  SQLCommand onDelete({String action}) {
    action = action.toLowerCase();
    String type = _onAction(action: action, actionType: 'delete');
    _onDelete = type;
    return this;
  }

  SQLCommand onUpdate({String action}) {
    action = action.toLowerCase();
    String type = _onAction(action: action, actionType: 'update');
    _onUpdate = type;
    return this;
  }

  String _onAction({String action, String actionType}) {
    action = action.toLowerCase();
    String type = actionType == 'update' ? 'ON UPDATE' : 'ON DELETE';
    switch (action) {
      case 'set default':
        type += ' SET DEFAULT';
        break;
      case 'set null':
        type += ' SET NULL';
        break;
      case 'cascade':
        type += ' CASCADE';
        break;
      case 'no action':
      case 'restrict':
      default:
        type = '';
    }
    return type;
  }

  String _argsGeneratorFromList(List<String> list) {
    int cnt = 1;
    StringBuffer str = StringBuffer();

    str.write('(');

    list.forEach((col) {
      String comma = cnt++ < list.length ? ',' : '';
      str.write('`$col`');
      str.write(comma);
    });

    str.write(')');

    return str.toString();
  }
}
