import 'package:encrypt/encrypt.dart';
import 'package:flutter_config/flutter_config.dart';

class EndToEndEncryption {
  static String _keyString = FlutterConfig.get('NFKICKS_KEY');

  static encrypt({String data}) {
    final key = Key.fromUtf8(_keyString);
    final iv = IV.fromLength(16);
    final textEncrypt = Encrypter(AES(key));
    return textEncrypt.encrypt(data, iv: iv).base64;
  }

  static decrypt({String data}) {
    final key = Key.fromUtf8(_keyString);
    final iv = IV.fromLength(16);
    final textEncrypt = Encrypter(AES(key));
    return textEncrypt.decrypt64(data, iv: iv);
  }
}
