import 'package:airnote/services/database.dart';
import 'package:airnote/services/locator.dart';

class PassPhraseService {
  final DatabaseService _dbService = locator<DatabaseService>();

  Future<void> savePassPhrase(String uuid, String passPhrase) async {
    final paddedPassPhrase = passPhrase.length >= 32 ? passPhrase.substring(0, 32) : passPhrase.padRight(32, "0");
    this._dbService.savePassPhrase(uuid: uuid, passPhrase: paddedPassPhrase);
  }

  Future<String> getPassPhrase(String uuid) async {
    return await this._dbService.getPassPhrase(uuid);
  }
}
