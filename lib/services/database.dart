import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class DatabaseService {
  String filename = "airnote.db";
  Database db;
  StoreRef<String, String> passPhraseStore;

  DatabaseService() {
    this._initialiseDatabase();
  }

  _initialiseDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, this.filename);
    this.db = await databaseFactoryIo.openDatabase(dbPath);
    this.passPhraseStore = StoreRef<String, String>.main();
  }

  Future<bool> savePassPhrase(String email, String passPhrase) async {
    try {
      await passPhraseStore.record(email).put(db, passPhrase);
    } on Error catch (_) {
      return false;
    }
    return true;
  }

  Future<String> getPassPhrase(String email) async {
    try {
      final passPhrase = await passPhraseStore.record(email).get(db);
      return passPhrase;
    } on Error catch (err) {
      return null;
    }
  }
}
