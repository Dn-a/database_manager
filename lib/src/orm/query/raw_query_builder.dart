class RawQueryBuilder {
  RawQueryBuilder(
      {this.table,
      this.distinct = false,
      this.columns,
      this.wheres,
      this.groupBy,
      this.orderBy,
      this.limit,
      this.offset,
      this.having,
      this.values});

  final String table;
  final bool distinct;
  final List<String> columns;
  final String wheres;
  final String groupBy;
  final String orderBy;
  final int limit;
  final int offset;
  final String having;
  final List<dynamic> values;

  String getSQL() {
    StringBuffer str = StringBuffer();
    str.write(_DQL);
    str.write(_wheres);
    str.write(_groupBy);
    str.write(_having);
    str.write(_orderBy);
    str.write(_limitOffset);
    //print('rawQueryBuilder: ${str.length}');
    return str.toString();
  }

  String get _DQL {
    StringBuffer str = StringBuffer();

    if (_table.isEmpty) return str.toString();

    str.write('SELECT ');
    str.write(_distinct);
    str.write(_columns);
    str.write(' FROM ');
    str.write('$_table ');
    if (_wheres.isNotEmpty) str.write('WHERE ');

    return str.toString();
  }

  String get _distinct {
    return distinct ? 'DISTINCT ' : '';
  }

  String get _columns {
    return columns == null || columns.isEmpty ? '*' : columns.join(',');
  }

  String get _table {
    return table == null ? '' : table;
  }

  String get _wheres {
    return wheres == null ? '' : '$wheres ';
  }

  String get _groupBy {
    return groupBy == null ? '' : 'GROUP BY $groupBy ';
  }

  String get _orderBy {
    return orderBy == null ? '' : 'ORDER BY $orderBy ';
  }

  String get _limitOffset {
    final StringBuffer str = StringBuffer();
    if (limit != null) str.write('LIMIT $limit');
    if (str.isNotEmpty && offset != null) str.write(', $offset');
    return str.toString();
  }

  String get _having {
    return having == null ? '' : 'HAVING $having ';
  }
}
