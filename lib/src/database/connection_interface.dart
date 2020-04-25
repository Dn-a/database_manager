import '../orm/query/query_builder.dart';

typedef TransactionCallback = void Function(dynamic value);

abstract class ConnectionInterface {
  QueryBuilder table(String tableName);

  String raw(dynamic value);

  List select(String query);

  dynamic selectOne(String query);

  bool insert(String query);

  int update(String query);

  int delete(String query);

//  bool statement(String query);

//  dynamic transaction(TransactionCallback callback);

}
