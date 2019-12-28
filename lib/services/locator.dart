

import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/user.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => DialogService());
}