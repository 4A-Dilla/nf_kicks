import 'package:encrypt/encrypt.dart';

class EndToEndEncryption {
  static String keyString = "(H+MbQeT";

  static encrypt({String data}) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromLength(16);
    final textEncrypt = Encrypter(AES(key));
    return textEncrypt.encrypt(data, iv: iv).base64;
  }

  static decrypt({String data}) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromLength(16);
    final textEncrypt = Encrypter(AES(key));
    //textEncrypt.decrypt64(encoded)
    return textEncrypt.decrypt64(data, iv: iv);
  }
}
