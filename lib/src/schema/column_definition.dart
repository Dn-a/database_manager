import 'package:flutter/foundation.dart';

/// fluent interface implementation
///
class ColumnDefinition {
  final String _type;
  final String _name;
  final Map<String, dynamic> _parameters;

  ColumnDefinition(
      {@required String type,
      @required String name,
      Map<String, dynamic> parameters = const <String, dynamic>{}})
      : this._type = type,
        this._name = name,
        this._parameters = parameters;

  String _unsigned = '';
  String _autoincrement = '';
  final List<String> _defaultValue = [];
  final List<String> _indexCommand = [];

  final String _defaultValueAssertMsg =
      'be sure to use only one of the following parameters: nullable, defaultValue, useCurrent, autoIncrement';
  final String _indexCommandAssertMsg =
      '(Column definition) You can only have one KEY';

  String getSQLColumn() {
    final String notNull =
        _defaultValue.contains('NULL') ? 'DEFAULT' : 'NOT NULL DEFAULT';
    final String defaultValue =
        _defaultValue.length > 0 ? "$notNull ${_defaultValue[0]}" : 'NOT NULL';

    final StringBuffer sql = StringBuffer();

    sql.write("`$_name` $_type");

    if (_getParameter(name: 'length').isNotEmpty)
      sql.write('(${_getParameter(name: 'length')})');

    if (_getParameter(name: 'unsigned').isNotEmpty)
      sql.write(' ${_getParameter(name: 'unsigned')}');

    sql.write(' $defaultValue');

    if (_getParameter(name: 'autoincrement').isNotEmpty)
      sql.write(' ${_getParameter(name: 'autoincrement')}');

    return sql.toString();
  }

  String getSQLCommand() {
    return _indexCommand.length > 0 ? _indexCommand.first : '';
  }

  /// Property - default value
  ColumnDefinition nullable({bool value = true}) {
    if (value) _defaultValue.add('NULL');
    assert(_defaultValue.length > 1 || _autoincrement != ''
        ? throw _defaultValueAssertMsg
        : true);
    return this;
  }

  /// Property - default value
  ColumnDefinition defaultValue(dynamic value) {
    _defaultValue.add("'$value'");
    assert(_defaultValue.length > 1 || _autoincrement != ''
        ? throw _defaultValueAssertMsg
        : true);
    return this;
  }

  /// Property - default value
  ColumnDefinition useCurrent() {
    assert(_type == 'DATETIME' || _type == 'TIMESTAMP'
        ? true
        : throw 'useCurrent only works on Datatime or timestamp');
    _defaultValue.add('CURRENT_TIMESTAMP');
    return this;
  }

  /// Property
  /// Note: AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY, not UNSIGNED, not without PRIMARY KEY
  ColumnDefinition autoIncrement() {
    String msg = 'AutoIncrement only works on numbers';
    assert(_type == 'TINYINT' ||
            _type == 'SMALLINT' ||
            _type == 'MEDIUMINT' ||
            _type == 'BIGINT' ||
            _type == 'INTEGER' ||
            _type == 'NUMBER'
        ? true
        : throw msg);
    assert(_indexCommand.length > 0 ? throw _indexCommandAssertMsg : true);
    _autoincrement = 'AUTOINCREMENT';
    //primary();
    return this;
  }

  /// Property
  ColumnDefinition unsigned() {
    String msg = 'Unsigned only works on numbers';
    assert(_type == 'TINYINT' ||
            _type == 'SMALLINT' ||
            _type == 'MEDIUMINT' ||
            _type == 'BIGINT' ||
            _type == 'INTEGER' ||
            _type == 'NUMBER'
        ? true
        : throw msg);
    _unsigned = 'unsigned';
    return this;
  }

  /// Key
  ColumnDefinition primary() {
    String sql = 'PRIMARY KEY (`$_name`)';
    _indexCommand.add(sql);
    assert(_indexCommand.length > 1 ? throw _indexCommandAssertMsg : true);
    return this;
  }

  /// key
  ColumnDefinition unique() {
    String sql = 'UNIQUE (`$_name`)';
    _indexCommand.add(sql);
    assert(_indexCommand.length > 1 ? throw _indexCommandAssertMsg : true);
    return this;
  }

  /// Key
  ColumnDefinition index({String indexName = ''}) {
    String sql = 'KEY `${_name}_$indexName` (`$_name`)';
    _indexCommand.add(sql);
    assert(_indexCommand.length > 1 ? throw _indexCommandAssertMsg : true);
    return this;
  }

  String _getParameter({@required String name}) {
    String str = '';

    switch (name) {
      case 'autoincrement':
        if (_autoincrement.isNotEmpty ||
            (_parameters['autoincrement'] != null &&
                _parameters['autoincrement']))
          str = 'PRIMARY KEY AUTOINCREMENT';
        break;
      case 'unsigned':
        if (_unsigned.isNotEmpty ||
            (_parameters['unsigned'] != null && _parameters['unsigned']))
          str = 'UNSIGNED';
        break;
      case 'length':
        String msg = 'Length must be a positive integer > 0 ';
        assert(_parameters['length'] != null && _parameters['length'] <= 0
            ? throw msg
            : true);
        if (_parameters['length'] != null)
          str = _parameters['length'].toString();
    }

    return str;
  }
}
