// lib/utils/aes_encryptor.dart
import 'package:encrypt/encrypt.dart';

class AesEncryptor {
  static const String _keyString = 'cipherprmytpipay'; // 16 chars → AES-128

  static final Key _key = Key.fromUtf8(_keyString);
  static final Encrypter _encrypter = Encrypter(
    AES(_key, mode: AESMode.ecb), // same as Java AES/ECB/PKCS5Padding
  );

  static String encryptToBase64(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: IV.fromLength(0));
    return encrypted.base64;
  }

  static String decryptFromBase64(String base64Encrypted) {
    final enc = Encrypted.fromBase64(base64Encrypted);
    return _encrypter.decrypt(enc, iv: IV.fromLength(0));
  }
}
