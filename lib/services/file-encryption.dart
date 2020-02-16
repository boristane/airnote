import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class FileEncryptionService {
  
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

  _writeFile(List<int> data, String path) async {
    final File file = File(path);
    await file.writeAsBytes(data);
  }

  encryptFile(String path, String passPhrase, String encryptionKey) async {
    final key = Key.fromUtf8(passPhrase);
    final iv = IV.fromBase64(encryptionKey);

    final encrypter = Encrypter(AES(key));
    final data = await _readFile(path);

    final encrypted = encrypter.encryptBytes(data, iv: iv);

    await _writeFile(encrypted.bytes, path);
  }

  decryptFile(String path, String passPhrase, String encryptionKey) async {
    final key = Key.fromUtf8(passPhrase);
    final iv = IV.fromBase64(encryptionKey);

    final encrypter = Encrypter(AES(key));
    final data = await _readFile(path);

    final encrypted = Encrypted(data);
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);

    await _writeFile(decrypted, path);
  }
}
