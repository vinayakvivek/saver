import 'package:hive/hive.dart';
import 'package:saver/aes_encrypter.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  Account({
    required this.name,
    required this.username,
    required this.password,
    required this.iconName,
  });

  factory Account.empty() {
    return Account(name: "", username: "", password: "", iconName: "");
  }

  @HiveField(0)
  String name;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  @HiveField(3)
  String? iconName;

  @override
  String toString() {
    return "Account{name: $name, username: $username, passwordLength: ${password.length}, iconName: $iconName}";
  }

  toEncryptedJson(AESEncrypter encrypter) => {
        'name': name,
        'username': username,
        'password': encrypter.encrypt(password),
        'iconName': iconName,
      };

  factory Account.fromEncryptedJson(
          Map<String, dynamic> json, AESEncrypter encrypter) =>
      Account(
        name: json['name'],
        username: json['username'],
        password: encrypter.decrypt(json['password']),
        iconName: json['iconName'] ?? '',
      );
}
