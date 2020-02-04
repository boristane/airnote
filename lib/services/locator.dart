

import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/entry.dart';
import 'package:airnote/services/local_auth.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/services/user.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => EntryService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackBarService());
  locator.registerLazySingleton(() => LocalAuthService());
}