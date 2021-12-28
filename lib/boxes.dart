import 'package:hive/hive.dart';
import 'package:saver/account.dart';

const kAccountBox = 'accounts';

class Boxes {
  static Box<Account> getAccounts() => Hive.box<Account>(kAccountBox);
}
