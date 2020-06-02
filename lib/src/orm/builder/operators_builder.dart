part of orm_builder;

/// Recursive Generics
/// Fluent Interface implementation
///
class OperatorBuilder<T extends OperatorBuilder<T>> {
  QueryBuilder _query = QueryBuilder();

  T select(List<String> columns) {
    _query.select(columns);
    return this;
  }

  T from(String table) {
    _query.from(table: table);
    return this;
  }

  T distinct([bool active = true]) {
    _query.setDistinct = active;
    return this;
  }

  T where(
      {String column,
      String operator = '=',
      dynamic value,
      String condition = 'AND',
      SubQueryCallback nested}) {
    if (nested != null)
      _query.whereNested(
          column: column,
          operator: operator,
          condition: condition,
          nested: _subQuery(nested));
    else
      _query.where(
          column: column,
          operator: operator,
          values: [value],
          condition: condition);
    return this;
  }

  T orWhere(
      {@required String column,
      String operator = '=',
      @required dynamic value,
      SubQueryCallback nested}) {
    this.where(
        column: column,
        operator: operator,
        value: value,
        condition: 'OR',
        nested: nested);
    return this;
  }

  T whereRaw(String raw, {List bindings, String condition = 'AND'}) {
    _query.whereRaw(raw, bindings: bindings, condition: condition);
    return this;
  }

  T orWhereRaw(String raw, {List bindings}) {
    this.whereRaw(raw, bindings: bindings, condition: 'OR');
    return this;
  }

  T whereIn(
      {@required String column,
      @required List<dynamic> values,
      String condition = 'AND',
      SubQueryCallback nested}) {
    if (nested != null)
      _query.whereNested(
          column: column,
          operator: 'IN',
          condition: condition,
          nested: _subQuery(nested));
    else
      _query.where(
          column: column, operator: 'IN', values: values, condition: condition);
    return this;
  }

  T orWhereIn(
      {@required String column,
      @required List<dynamic> values,
      SubQueryCallback nested}) {
    this.whereIn(
        column: column, values: values, condition: 'OR', nested: nested);
    return this;
  }

  T whereNotIn(
      {@required String column,
      @required List<dynamic> values,
      String condition = 'AND',
      SubQueryCallback nested}) {
    if (nested != null)
      _query.whereNested(
          column: column,
          operator: 'NOT IN',
          condition: condition,
          nested: _subQuery(nested));
    else
      _query.where(
          column: column,
          operator: 'NOT IN',
          values: values,
          condition: condition);
    return this;
  }

  T orWhereNotIn(
      {@required String column,
      @required List<dynamic> values,
      SubQueryCallback nested}) {
    this.whereNotIn(
        column: column, values: values, condition: 'OR', nested: nested);
    return this;
  }

  T whereExists(SubQueryCallback nested, {String condition = 'AND'}) {
    _query.whereNested(
        condition: condition, nested: _subQuery(nested), exists: true);
    return this;
  }

  T orWhereExists(SubQueryCallback nested) {
    this.whereExists(nested, condition: 'OR');
    return this;
  }

  T whereNotExists(SubQueryCallback nested, {String condition = 'AND'}) {
    _query.whereNested(
        condition: condition,
        operator: 'NOT',
        nested: _subQuery(nested),
        exists: true);
    return this;
  }

  T orWhereNotExists(SubQueryCallback nested) {
    this.whereNotExists(nested, condition: 'OR');
    return this;
  }

  /// Ordering, Grouping, Limit & Offset

  T orderBy(List<String> columns, {String type}) {
    _query.orderBy(columns, type: type);
    return this;
  }

  T orderByDesc(List<String> columns) {
    this.orderBy(columns, type: 'DESC');
    return this;
  }

  T orderByAsc(List<String> columns) {
    this.orderBy(columns, type: 'ASC');
    return this;
  }

  T groupBy(List<String> columns) {
    _query.groupBy(columns);
    return this;
  }

  T limit(int value) {
    assert(value >= 0 ? true : throw 'The limit must be > = 0');
    _query.setLimit = value;
    return this;
  }

  T offset(int value) {
    assert(value >= 0 ? true : throw 'The offset must be > = 0');
    _query.setOffset = value;
    return this;
  }

  T having(
      {@required String column,
      String operator = '=',
      @required dynamic value,
      String condition = 'AND'}) {
    _query.having(
        column: column, operator: operator, value: value, condition: condition);
    return this;
  }

  T orHaving(
      {@required String column,
      String operator = '=',
      @required dynamic value}) {
    this.having(
        column: column, operator: operator, value: value, condition: 'OR');
    return this;
  }

  String _getTable() {
    return _query.table;
  }

  bool _getDistinct() {
    return _query.distinct;
  }

  List<String> _getColumns() {
    return _query.columns;
  }

  String _getWhere() {
    String str = _query.whereColumns;
    return str.isEmpty ? null : str;
  }

  List<dynamic> _getWhereArgs() {
    return _query.wheresArgs;
  }

  int _getLimit() {
    return _query.limit;
  }

  int _getOffset() {
    return _query.offset;
  }

  String _getGroupBy() {
    String str = _query.groups;
    return str.isEmpty ? null : str;
  }

  String _getOrderBy() {
    String str = _query.orders;
    return str.isEmpty ? null : str;
  }

  String _getHavings() {
    String str = _query.havings;
    return str.isEmpty ? null : str;
  }

  RawQueryBuilder _subQuery(SubQueryCallback nested) {
    if (nested == null) return null;
    final OperatorBuilder builder = SubqueryBuilder();
    nested(builder);
    final RawQueryBuilder rawQuery = RawQueryBuilder(
        columns: builder._getColumns(),
        distinct: builder._getDistinct(),
        table: builder._getTable(),
        wheres: builder._getWhere(),
        orderBy: builder._getOrderBy(),
        groupBy: builder._getGroupBy(),
        limit: builder._getLimit(),
        offset: builder._getOffset(),
        having: builder._getHavings(),
        values: builder._getWhereArgs());

    return rawQuery;
  }
}

class SubqueryBuilder extends OperatorBuilder<SubqueryBuilder> {}
