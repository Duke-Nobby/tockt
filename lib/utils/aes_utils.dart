import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

class AesUtils {
  static String encryptAES(String content) {
    final key = encrypt.Key.fromUtf8("4D1132EC599B505F");
    final iv = encrypt.IV.fromUtf8("");
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    final encrypted = encrypter.encrypt(content, iv: iv);
    final encryptStr = encrypted.base64;
    return base64Decode(LineSplitter.split(encryptStr).join()).map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}
