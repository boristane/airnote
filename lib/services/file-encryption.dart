import 'dart:io';

import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class FileEncryptionService {
  final _iv = IV.fromLength(16);
  
  Future<Uint8List> _readFile(String path) async {
    Uint8List data;
    try {
      final File file = File(path);
      data = await file.readAsBytes();
    } catch (e) {
      print("Couldn't read file");
    }
    return data;
  }

  _writeFile(Uint8List data, String path) async {
    final File file = File(path);
    await file.writeAsBytes(data);
  }

  encryptFile(String path, String passPhrase) async {
    final key = Key.fromUtf8(passPhrase);

    final encrypter = Encrypter(AES(key));
    final data = await _readFile(path);

    final encrypted = encrypter.encryptBytes(data, iv: _iv);
    final decrypted = encrypter.decryptBytes(encrypted, iv: _iv);

    print(decrypted);
    print(data);
    print(encrypted.bytes);

    await _writeFile(encrypted.bytes, path);
  }
}
