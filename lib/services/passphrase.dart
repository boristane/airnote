import 'package:path_provider/path_provider.dart';

class PassPhraseService {
  Future<String> savePassPhrase(String passPhrase) async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }
}