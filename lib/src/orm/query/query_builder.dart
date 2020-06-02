import 'raw_query_builder.dart';
import 'package:flutter/foundation.dart';

class QueryBuilder {
  Map<String, List> _bindings = {
    'select': [],
    'from': [],
    'join': [],
    'where': [],
    'having': [],
    'order': [],
    'union': [],
  };

  List _operators = [
    '=',
    '<',
    '>',
    '<=',
    '>=',
    '<>',
    '!=',
    '<=>',
    'like',
    'like binary',
    'not like',
    'ilike',
    '&',
    '|',
    '^',
    '<<',
    '>>',
    'rlike',
    'not rlike',
    'regexp',
    'not regexp',
    '~',
    '~*',
    '!~',
    '!~*',
    'similar to',
    'not similar to',
    'not ilike',
    '~~*',
    '!~~*',
  ];

  final List<String> _columns = [];
  String _table;
  bool _distinct = false;
  final List _joins = [];
  final List<Map<String, dynamic>> _whereColumns = [];
  final List<dynamic> _wheresArgs = [];
  final List _groups = [];
  final List<Map<String, String>> _orders = [];
  final List<Map<String, dynamic>> _havings = [];
  int _limit;
  int _offset;
  List unions;
  int unionLimit;
  int unionOffset;

  QueryBuilder from({String table}) {
    _table = table;
    return this;
  }

  QueryBuilder select(List<String> columns) {
    this._columns.addAll(columns);
    return this;
  }

  QueryBuilder where(
      {@required String column,
      String operator = '=',
      @required List<dynamic> values,
      String condition = 'AND'}) {
    if (column == null || values == null) return this;

    _whereColumns.add({
      'column': column,
      'operator': operator,
      'condition': condition,
      'argsSize': values.length
    });
    _wheresArgs.addAll(values);

    return this;
  }

  QueryBuilder whereRaw(String raw, {List bindings, String condition = 'AND'}) {
    _whereColumns.add({'raw': raw, 'condition': condition});
    if (bindings != null) _wheresArgs.addAll(bindings);

    return this;
  }

  QueryBuilder whereNested(
      {String column,
      String operator = '',
      String condition = 'AND',
      RawQueryBuilder nested,
      bool exists = false}) {
    if (nested == null || nested.getSQL().isEmpty) return this;

    _whereColumns.add({
      'column': column,
      'operator': operator,
      'condition': condition,
      'nested': nested.getSQL(),
      'exists': exists
    });
    _wheresArgs.addAll(nested.values);

    return this;
  }

  QueryBuilder orderBy(List<String> columns, {String type}) {
    columns.forEach((col) {
      _orders.add({'column': col, 'type': type});
    });
    return this;
  }

  QueryBuilder groupBy(List<String> columns) {
    _groups.addAll(columns);
    return this;
  }

  QueryBuilder having(
      {@required String column,
      String operator = '=',
      @required dynamic value,
      String condition = 'AND'}) {
    _havings.add({
      'column': column,
      'operator': operator,
      'condition': condition,
      'value': value
    });
    return this;
  }

  QueryBuilder subQuery() {
    return this;
  }

  String get table {
    return _table;
  }

  List<String> get columns {
    return _columns;
  }

  set setDistinct(bool val) => _distinct = val;
  bool get distinct {
    return _distinct;
  }

  set setLimit(int val) => _limit = val;
  int get limit {
    return _limit;
  }

  set setOffset(int val) => _offset = val;
  int get offset {
    return _offset;
  }

  String get groups {
    return _groups.join(',');
  }

  String get orders {
    List<String> ords = _orders.map((grp) {
      String type = grp['type'] == null ? '' : grp['type'].toLowerCase();
      type = type != 'asc' && type != 'desc' ? '' : type;
      return grp['column'] + (type.length > 0 ? ' $type' : '');
    }).toList();
    return ords.join(',');
  }

  String get havings {
    StringBuffer str = StringBuffer();
    int size = _havings.length;
    int cnt = 0;

    _havings.forEach((grp) {
      //str.write('`${grp['column']}`');
      str.write('${grp['column']}');
      str.write(' ');
      str.write(grp['operator']);
      str.write(' ');

      if (grp['value'].runtimeType == String)
        str.write("'${grp['value']}'");
      else
        str.write(grp['value']);

      if (size > 1) {
        String cond = _havings[++cnt]['condition'];
        str.write(' ');
        str.write(cond);
        str.write(' ');
        --size;
      }
    });
    return str.toString();
  }

  /// Prepare a String for the where condition
  String get whereColumns {
    final StringBuffer str = StringBuffer();

    int size = _whereColumns.length;
    int cnt = 0;

    _whereColumns.forEach((clm) {
      str.write(_prepareWhereStatement(clm));
      // inserts 'AND, OR' if where condition is > 1
      if (size > 1) {
        String cond = _whereColumns[++cnt]['condition'];
        str.write(' ');
        str.write(cond);
        str.write(' ');
        --size;
      }
    });
    return str.toString();
  }

  List<dynamic> get wheresArgs {
    return _wheresArgs;
  }

  String _prepareWhereStatement(Map<String, dynamic> clm) {
    final StringBuffer str = StringBuffer();
    final String column = clm['column'] == null ? '' : clm['column'];
    final String operator = clm['operator'] == null ? '' : clm['operator'];
    final String nested = clm['nested'] == null ? '' : clm['nested'];
    final String raw = clm['raw'] == null ? '' : clm['raw'];
    final bool exists = clm['exists'] == null ? false : clm['exists'];

    assert((column.isNotEmpty && operator.isNotEmpty && !exists) ||
            (column.isEmpty && nested.isNotEmpty) ||
            (column.isEmpty && raw.isNotEmpty)
        ? true
        : throw 'The column field and the operator field cannot be empty.');

    if (raw.isNotEmpty)
      str.write(raw);
    else {
      if (column.isNotEmpty) {
        str.write(column);
        str.write(' ');
      }

      if ((operator == 'IN' || operator == 'NOT IN') && nested.isEmpty)
        str.write(_whereInBindingGenerator(clm['argsSize'], clm['operator']));
      else if (operator.isNotEmpty && column.isNotEmpty) {
        str.write(operator);
        str.write(' ');
        if (nested.isEmpty) str.write('?');
      }

      if (nested.isNotEmpty) {
        if (exists) str.write('EXISTS ');
        str.write('(');
        str.write(nested);
        str.write(')');
      }
    }
    return str.toString();
  }

  /// Generate where IN ---> IN (?,?,..)
  String _whereInBindingGenerator(int size, String operator) {
    StringBuffer str = StringBuffer();

    str.write('$operator (');

    for (int i = 0; i < size; i++) {
      str.write('?');
      if (i + 1 < size) str.write(',');
    }

    str.write(')');

    return str.toString();
  }
}
