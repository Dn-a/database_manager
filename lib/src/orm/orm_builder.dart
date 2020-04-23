import 'package:database_manager/src/orm/query/query_builder.dart';
import 'package:flutter/foundation.dart';

class ORMBuilder {
  final QueryBuilder _query;

  ORMBuilder({@required QueryBuilder query}) : this._query = query;

  ORMBuilder where(
      {@required dynamic column,
      String operator = '=',
      @required dynamic value}) {
    return this;
  }
}
