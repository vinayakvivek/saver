import 'package:hive/hive.dart';
import 'package:saver/aes_encrypter.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  Account({
    required this.name,
    required this.username,
    required this.password,
  });

  factory Account.empty() {
    return Account(name: "", username: "", password: "");
  }

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

  toEncryptedJson(AESEncrypter encrypter) => {
        'name': name,
        'username': username,
        'password': encrypter.encrypt(password),
      };

  factory Account.fromEncryptedJson(
          Map<String, dynamic> json, AESEncrypter encrypter) =>
      Account(
        name: json['name'],
        username: json['username'],
        password: encrypter.decrypt(json['password']),
      );
}
