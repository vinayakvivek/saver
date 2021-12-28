import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  Account({
    required this.name,
    required this.username,
    required this.password,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  @override
  String toString() {
    return "Account{name: $name, username: $username, passwordLength: ${password.length}}";
  }
}
