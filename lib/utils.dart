import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';

String paddedPassphrase(String passphrase) {
  final n = passphrase.length;
  if (n == 32) return passphrase;
  if (n > 32) return passphrase.substring(0, 32);
  passphrase += "0" * (32 - n);
  return passphrase;
}

String dateString() {
  final date = DateTime.now();
  return "${date.day}_${date.month}_${date.year}_${date.hour}_${date.minute}_${date.second}";
}

Future<File> exportAccountsToFile({required String passphrase}) async {
  passphrase = paddedPassphrase(passphrase);
  final key = Key.fromUtf8(passphrase);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final box = Boxes.getAccounts();
  final accounts = box.values.toList().cast<Account>();
  Map<String, dynamic> accountsMap = {
    'accounts': accounts
        .map((account) => {
              'name': account.name,
              'username': account.username,
              'password': encrypter.encrypt(account.password, iv: iv).base64,
            })
        .toList()
  };
  final content = jsonEncode(accountsMap);

  final directory = await getApplicationDocumentsDirectory();
  final fileName = "data_export_${dateString()}.json";
  final file = File("${directory.path}/$fileName");
  final outFile = await file.writeAsString(content);
  return outFile;
}

void importAccountsFromFile({
  required File file,
  required String passphrase,
}) {
  passphrase = paddedPassphrase(passphrase);
  final key = Key.fromUtf8(passphrase);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final content = jsonDecode(file.readAsStringSync());
  final accounts = (content['accounts'] as List).map(
    (obj) => Account(
      name: obj['name'],
      username: obj['username'],
      password: encrypter.decrypt64(obj['password'], iv: iv),
    ),
  );

  final box = Boxes.getAccounts();
  final currentKeys = List.from(box.keys);
  for (var account in accounts) {
    box.add(account);
  }
  box.deleteAll(currentKeys);
}
