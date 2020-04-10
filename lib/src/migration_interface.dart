
import 'package:flutter/foundation.dart';

abstract class Migration{

  /// run the migrations
  @required
  void up();

  /// reverse the migrations
  @required
  void down();
}
