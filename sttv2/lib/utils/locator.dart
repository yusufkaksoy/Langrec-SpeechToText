import 'package:sttv2/services/api_manager.dart';
import 'package:sttv2/services/i_api_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<IApiService>(() => ApiManager());
}
