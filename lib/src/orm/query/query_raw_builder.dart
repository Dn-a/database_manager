

class QueryRawBuilder {

  QueryRawBuilder({
    this.table,
    this.distinct,
    this.columns,
    this.wheres,
    this.operator,
    this.groupBy,
    this.orderBy,
    this.limit,
    this.offset,
    this.having,
  });

  final String table;
  final bool distinct;
  final List<String> columns;
  final String wheres;
  final String operator;
  final String groupBy;
  final String orderBy;
  final int limit;
  final int offset;
  final String having;

  String getSQL(){
    StringBuffer str = StringBuffer();
    str.write('SELECT');
    str.write(_distinct());
    str.write(' FROM ');
    str.write(_table);
    str.write(' WHERE ');
    str.write(_wheres);
    str.write(_orderBy());
    str.write(_groupBy());

    return str.toString();
  }

  String  _distinct(){
    return distinct ? ' DISTINCT ':'';
  }

  String  _table(){
    assert(table.isNotEmpty? true : throw 'QueryRawBuilder: table field is empty');
    return table;
  }

  String  _wheres(){
    return wheres==null ? '' : wheres;
  }

  String  _groupBy(){
    return groupBy==null ? '' : groupBy;
  }

  String  _orderBy(){
    return orderBy==null ? '' : orderBy;
  }

  String  _having(){
    return having==null ? '' : having;
  }
}