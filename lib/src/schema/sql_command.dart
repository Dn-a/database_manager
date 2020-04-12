
import 'package:flutter/foundation.dart';

class SQLCommand {

  final String _name;
  final Map<String, dynamic> _parameters;

  SQLCommand({
    @required String name,
    Map<String,dynamic> parameters = const <String,dynamic>{}
  }): this._name = name,
      this._parameters = parameters;

  String _on = '';
  String _references = '';

  String _onDelete = '';
  String _onUpdate = '';

  String getSQL(){

    switch(_name){
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
      default:
        return '';
    }
  }

  String _primaryGenerator(){
    StringBuffer str = StringBuffer();

    str.write('PRIMARY KEY');
    str.write( _argsGeneratorFromList( _parameters['columns'] ) );

    return str.toString();
  }

  String _uniqueGenerator(){
    var indexName = _parameters['indexName']!=null ? _parameters['indexName'] : '';

    StringBuffer str = StringBuffer();

    str.write('UNIQUE KEY');
    if( indexName.isNotEmpty )
      str.write( '`$indexName`' );
    str.write( _argsGeneratorFromList( _parameters['columns'] ) );

    return str.toString();
  }

  String _indexGenerator(){
    var indexName = _parameters['indexName']!=null ? _parameters['indexName'] : '';

    StringBuffer str = StringBuffer();

    str.write('KEY');
    if( indexName.isNotEmpty )
      str.write( '`$indexName`' );
    str.write( _argsGeneratorFromList( _parameters['columns'] ) );

    return str.toString();
  }

  String _foreignGenerator(){
    StringBuffer str = StringBuffer();

    str.write('FOREIGN KEY');
    str.write( _argsGeneratorFromList( _parameters['columns'] ) );
    str.write( ' REFERENCES ' );
    str.write( '`$_on`' );
    str.write( '$_references' );
    if(_onDelete.isNotEmpty)
      str.write( ' $_onDelete' );
    if(_onUpdate.isNotEmpty)
      str.write( ' $_onUpdate' );

    return str.toString();
  }

  String _dropGenerator(){
    var tableName = _parameters['tableName']!=null ? _parameters['tableName'] : '';
    StringBuffer str = StringBuffer();

    str.write('DROP $tableName IF EXISTS');

    return str.toString();
  }

  SQLCommand references({@required List<String> idList}){
    _references = _argsGeneratorFromList(idList);
    return this;
  }

  SQLCommand on({@required String tableName}){
    _on = tableName;
    return this;
  }

  SQLCommand onDelete({String action}){
    action = action.toLowerCase();
    String type = _onAction(action: action, actionType: 'delete');
    _onDelete = type;
    return this;
  }

  SQLCommand onUpdate({String action}){
    action = action.toLowerCase();
    String type = _onAction(action: action, actionType: 'update');
    _onUpdate = type;
    return this;
  }

  String _onAction({String action, String actionType}){
    action = action.toLowerCase();
    String type = actionType =='update' ? 'ON UPDATE' : 'ON DELETE';
    switch(action){
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

  String _argsGeneratorFromList(List<String> list){
    int cnt = 1;
    StringBuffer str = StringBuffer();

    str.write('(');

    list.forEach((col) {
      String comma = cnt++ < list.length ? ',': '';
      str.write('`$col`');
      str.write( comma );
    });

    str.write(')');

    return str.toString();
  }

}