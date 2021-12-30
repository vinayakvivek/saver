import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var rawKey = await secureStorage.read(key: 'key');
  var key;
  if (rawKey == null) {
    print('rawKey is null - generating and saving');
    key = Hive.generateSecureKey();
    print('boxKey: ' + key.toString());
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  } else {
    print('rawKey: $rawKey \nRetrieving and converting to Uint8List');
    key = base64Decode(rawKey);
    print('boxKey: ' + key.toString());
  }

  await Hive.openBox<Account>(
    kAccountBox,
    encryptionCipher: HiveAesCipher(key),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
