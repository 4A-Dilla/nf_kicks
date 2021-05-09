// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String _keyString = env['NFKICKS_KEY'].toString();
final Key _key = Key.fromUtf8(_keyString);
final IV _iv = IV.fromLength(16);
final Encrypter _textEncrypt = Encrypter(AES(_key));

class EndToEndEncryption {
  static String encrypt({String data}) {
    return _textEncrypt.encrypt(data, iv: _iv).base64;
  }

  static String decrypt({String data}) {
    return _textEncrypt.decrypt64(data, iv: _iv);
  }

  static String hash({String password}) {
    final _bytes = utf8.encode(password);
    final _hash = sha512.convert(_bytes);
    return _hash.toString();
  }
}
