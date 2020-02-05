import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

class PassPhraseService {
  final String key = "qv8FYaE6AkDB7pSAxZeBAhZd7DE7ptvc";
  Future<String> savePassPhrase(String passPhrase) async {
  
  final key = Key.fromUtf8(this.key);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(passPhrase, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  print(encrypted.base64);
    final dir = await getTemporaryDirectory();
    return dir.path;
  }
}