import 'package:flutter/foundation.dart';
import '../../database/connection.dart';

class QueryBuilder {
  Connection connection;

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

  List<String> columns;
  bool distinct;
  String table;
  final List joins = [];
  final List<Map<String, String>> _whereColumns = [];
  final List<dynamic> wheresArgs = [];
  List groups;
  List havings;
  int limit;
  int offset;
  List unions;
  int unionLimit;
  int unionOffset;

  QueryBuilder({@required this.connection});

  QueryBuilder select({List<String> columns = const ['*']}) {
    this.columns = columns;
    return this;
  }

  QueryBuilder from({String table}) {
    table = table;
    return this;
  }

  QueryBuilder selectRaw({String expression}) {
    return this;
  }

  QueryBuilder where({
    @required String column,
    String operator = '=',
    @required List<dynamic> values,
    String condition = 'AND',
  }) {
    _whereColumns.add({
      'column': column,
      'operator': operator,
      'condition': condition,
      'argsSize': values.length.toString()
    });

    values.forEach((v) => wheresArgs.add(v));

    return this;
  }

  /// Prepare a String for the where condition
  String get whereColumns {
    final StringBuffer str = StringBuffer();

    int size = _whereColumns.length;
    int cnt = 0;

    _whereColumns.forEach((clm) {
      str.write('`${clm['column']}`');
      str.write(' ');

      if (clm['operator'] == 'IN' || clm['operator'] == 'NOT IN')
        str.write(
            _whereInGenerator(int.parse(clm['argsSize']), clm['operator']));
      else
        str.write('${clm['operator']} ?');

      // inserts 'AND, OR' if where condition is > 1
      if (size > 1) {
        String cond = _whereColumns[++cnt]['condition'];

        str.write(' ');
        str.write(cond);
        str.write(' ');

        --size;
      }
    });

    print(str);
    return str.toString();
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
