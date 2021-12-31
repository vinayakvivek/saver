import 'package:encrypt/encrypt.dart';

/// Converts a string into a string of length 32
/// if the input has smaller length, it'll be padded with '0's to make it 32
/// if more than 32, first 32 length substring will be used
String padTo32(String passphrase) {
  final n = passphrase.length;
  if (n == 32) return passphrase;
  if (n > 32) return passphrase.substring(0, 32);
  passphrase += "0" * (32 - n);
  return passphrase;
}

class AESEncrypter {
  final String passphrase;
  late String paddedPassphrase;
  late Key key;
  late IV iv;
  late Encrypter encrypter;

  AESEncrypter(this.passphrase) {
    paddedPassphrase = padTo32(passphrase);
    key = Key.fromUtf8(paddedPassphrase);
    iv = IV.fromLength(16);
    encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  }

  /// returns base64 encoded encrypted value of [content]
  encrypt(String content) {
    return encrypter.encrypt(content, iv: iv).base64;
  }

  /// [content] should be base64 encoded encrypted value
  decrypt(String content) {
    return encrypter.decrypt64(content, iv: iv);
  }
}
