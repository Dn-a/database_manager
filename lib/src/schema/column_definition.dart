
import 'package:flutter/foundation.dart';

/// fluent interface implementation
///
class ColumnDefinition{

  final String _type;
  final String _name;
  final Map<String,dynamic> _parameters;

  ColumnDefinition({
    @required String type,
    @required String name,
    Map<String,dynamic> parameters = const <String,dynamic>{}
  }): this._type = type,
        this._name = name,
        this._parameters = parameters;

  String _unsigned = '';
  String _autoincrement = '';
  final List<String> _defaultValue = [];


  /*List<String> _getUniqueProperties(){
  }*/

  String getSQL(){
    String msg = 'Length must be a positive integer greater than one';
    assert( _parameters['length']!=null && _parameters['length'] <= 0 ? throw msg : true );

    final String notNull = _defaultValue.contains('NULL') ? 'DEFAULT' : 'NOT NULL DEFAULT';
    final String defaultValue = _defaultValue.length> 0 ? "$notNull ${_defaultValue[0]}": 'NOT NULL';

    final StringBuffer sql = StringBuffer("`$_name` $_type");

    if(_parameters['length']!=null)
      sql.write( '(${_parameters['length']})' );

    if(_unsigned.isNotEmpty)
      sql.write( ' $_unsigned' );
    else if(_parameters['unsigned']!=null && _parameters['unsigned'])
      sql.write( ' unsigned' );

    sql.write( ' $defaultValue' );

    if(_autoincrement.isNotEmpty)
      sql.write( ' $_autoincrement' );
    else if(_parameters['autoincrement']!=null && _parameters['autoincrement'])
      sql.write( ' AUTOINCREMENT' );

    return sql.toString();
  }


  /// Property - default value
  ColumnDefinition nullable({bool value = true}){
    if(value)
      _defaultValue.add('NULL');
    String msg = 'be sure to use only one of the following parameters: nullable, defaultValue, useCurrent, autoIncrement';
    assert( _defaultValue.length > 1 || _autoincrement!='' ? throw msg : true );
    return this;
  }

  /// Property - default value
  ColumnDefinition defaultValue({@required dynamic value }){
    _defaultValue.add("'$value'");
    String msg = 'be sure to use only one of the following parameters: nullable, defaultValue, useCurrent, autoIncrement';
    assert( _defaultValue.length > 1 || _autoincrement!='' ? throw msg : true );
    return this;
  }

  /// Property - default value
  ColumnDefinition useCurrent(){
    assert(_type=='DATETIME' || _type=='TIMESTAMP' ? true : throw 'useCurrent only works on Datatime or timestamp' );
    _defaultValue.add('CURRENT_TIMESTAMP');
    return this;
  }

  /// Property
  ColumnDefinition autoIncrement(){
    String msg = 'AutoIncrement only works on numbers';
    assert( _type=='TINYINT' || _type=='SMALLINT' || _type=='MEDIUMINT' || _type=='BIGINT' ||  _type=='INTEGER' || _type=='NUMBER' ? true : throw msg );
     _autoincrement = 'AUTOINCREMENT';
    return this;
  }

  /// Property
  ColumnDefinition unsigned(){
    String msg = 'Unsigned only works on numbers';
    assert( _type=='TINYINT' || _type=='SMALLINT' || _type=='MEDIUMINT' || _type=='BIGINT' ||  _type=='INTEGER' || _type=='NUMBER' ? true : throw msg );
    _unsigned = 'unsigned';
    return this;
  }

  final List<String> _keys = [];
  /// key
  ColumnDefinition unique(){
    String sql = 'UNIQUE KEY `{$_name}_unique` (`{$_name}`)';
    _keys.add(sql);
    return this;
  }

  /// Key
  ColumnDefinition index({String indexName = ''}){
    String sql = 'KEY `${_name}_$indexName` (`{$_name}`)';
    _keys.add(sql);
    return this;
  }

  /// Key
  ColumnDefinition primary(){
    String sql = 'PRIMARY KEY (`{$_name}`)';
    _keys.add(sql);
    return this;
  }

}