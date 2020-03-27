

import 'package:airnote/services/database.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/entry.dart';
import 'package:airnote/services/file-encryption.dart';
import 'package:airnote/services/local-auth.dart';
import 'package:airnote/services/notifications.dart';
import 'package:airnote/services/passphrase.dart';
import 'package:airnote/services/quest.dart';
import 'package:airnote/services/routine.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/services/user.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(DatabaseService());
  locator.registerLazySingleton(() => QuestService());
  locator.registerLazySingleton(() => NotificationsService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => EntryService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackBarService());
  locator.registerLazySingleton(() => LocalAuthService());
  locator.registerLazySingleton(() => PassPhraseService());
  locator.registerLazySingleton(() => FileEncryptionService());
  locator.registerLazySingleton(() => RoutineService());
}