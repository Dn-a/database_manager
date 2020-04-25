import 'package:flutter/foundation.dart';
import '../../database/connection.dart';

class QueryBuilder {
  Connection connection;

  Map<String, List> bindings = {
    'select': [],
    'from': [],
    'join': [],
    'where': [],
    'having': [],
    'order': [],
    'union': [],
  };

  List operators = [
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

  List columns;
  bool distinct;
  String from;
  List joins;
  List wheres;
  List groups;
  List havings;
  int limit;
  int offset;
  List unions;
  int unionLimit;
  int unionOffset;

  QueryBuilder({@required this.connection});

  QueryBuilder select({List<String> columns = const ['*']}) {
    columns = columns;
    return this;
  }

  QueryBuilder where(
      {@required dynamic column,
      String operator = '=',
      @required dynamic value}) {
    return this;
  }
}
