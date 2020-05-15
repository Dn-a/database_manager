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
  final List joins = [];
  final List<Map<String, String>> _whereColumns = [];
  final List<dynamic> _wheresArgs = [];
  final List _groups = [];
  final List<Map<String, String>> _orders = [];
  final List<Map<String, dynamic>> _havings = [];
  final List<Map<String, dynamic>> _subQueries = [];
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
      String condition = 'AND',
      RawQueryBuilder nested}) {
    final String sqlNested = nested != null ? nested.getSQL() : '';
    if ((column == null || values == null) && sqlNested.isEmpty) return this;

    _whereColumns.add({
      'column': column,
      'operator': operator,
      'condition': condition,
      'argsSize': values.length.toString(),
      'nested': sqlNested
    });

    final args = nested != null ? nested.values : values;
    _wheresArgs.addAll(args);
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
      str.write('`${grp['column']}`');
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
      if (clm['nested'] != null && clm['nested'].isNotEmpty) {
        str.write('(');
        str.write(clm['nested']);
        str.write(')');
      } else {
        str.write('`${clm['column']}`');
        str.write(' ');
        if (clm['operator'] == 'IN' || clm['operator'] == 'NOT IN')
          str.write(
              _whereInGenerator(int.parse(clm['argsSize']), clm['operator']));
        else
          str.write('${clm['operator']} ?');
      }

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

  /// Generate where IN ---> IN (?,?,..)
  String _whereInGenerator(int size, String operator) {
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
