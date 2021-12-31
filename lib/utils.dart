import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver/aes_encrypter.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';

String dateString() {
  final date = DateTime.now();
  return "${date.day}_${date.month}_${date.year}_${date.hour}_${date.minute}_${date.second}";
}

Future<File> exportAccountsToFile({required String passphrase}) async {
  final encrypter = AESEncrypter(passphrase);

  final box = Boxes.getAccounts();
  final accounts = box.values.toList().cast<Account>();
  Map<String, dynamic> accountsMap = {
    'accounts':
        accounts.map((account) => account.toEncryptedJson(encrypter)).toList()
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
  final encrypter = AESEncrypter(passphrase);

  final content = jsonDecode(file.readAsStringSync());
  final accounts = (content['accounts'] as List).map(
    (obj) => Account.fromEncryptedJson(obj, encrypter),
  );

  final box = Boxes.getAccounts();
  final currentKeys = List.from(box.keys);
  for (var account in accounts) {
    box.add(account);
  }
  box.deleteAll(currentKeys);
}
