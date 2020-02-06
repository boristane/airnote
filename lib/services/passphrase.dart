import 'package:airnote/services/database.dart';
import 'package:airnote/services/locator.dart';
import 'package:encrypt/encrypt.dart';

class PassPhraseService {
  final _key = Key.fromUtf8("qv8FYaE6AkDB7pSAxZeBAhZd7DE7ptvc");
  final _iv = IV.fromLength(16);
  final DatabaseService _dbService = locator<DatabaseService>();

  Future<void> savePassPhrase(String email, String passPhrase) async {
    final encrypter = Encrypter(AES(this._key));
    final encrypted = encrypter.encrypt(passPhrase, iv: this._iv);
    this._dbService.savePassPhrase(email: email, passPhrase: encrypted.base64);
  }

  Future<bool> verifyPassPhrase(String email, String passPhrase) async {
    final encrypter = Encrypter(AES(this._key));
    final encrypted = Encrypted.from64(await _dbService.getPassPhrase(email));
    final decrypted = encrypter.decrypt(encrypted, iv: _iv);
    return decrypted == passPhrase;
  }
}
