import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class DatabaseService {
  String _filename = "airnote.db";
  Database _db;
  StoreRef<String, String> _passPhraseStore;

  DatabaseService() {
    this._initialiseDatabase();
  }

  _initialiseDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, this._filename);
    this._db = await databaseFactoryIo.openDatabase(dbPath);
    this._passPhraseStore = StoreRef<String, String>.main();
  }

  Future<void> savePassPhrase({String uuid, String passPhrase}) async {
    await this._passPhraseStore.record(uuid).put(_db, passPhrase);
  }

  Future<String> getPassPhrase(String uuid) async {
    try {
      final passPhrase = await _passPhraseStore.record(uuid).get(_db);
      return passPhrase;
    } on Error catch (_) {
      return null;
    }
  }
}
