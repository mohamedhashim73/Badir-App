import 'package:bader_user_app/Auth/Data/Data_Source/auth_data_source.dart';
import 'package:bader_user_app/Auth/Data/Repositories/auth_remote_repository.dart';
import 'package:bader_user_app/Layout/Data/Data_Source/clubs_remote_data_source.dart';
import 'package:bader_user_app/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:get_it/get_it.dart';

import '../../Layout/Data/Data_Source/events_remote_data_source.dart';

final GetIt sl = GetIt.instance;

class ServiceLocators{
  // TODO: Make Object from Classes That I want be created
  static Future<void> serviceLocatorInitialization() async {

    // TODO: Data Source Instance
    sl.registerLazySingleton<LayoutRemoteDataSource>(() => LayoutRemoteDataSource());
    sl.registerLazySingleton<ClubsRemoteDataSource>(() => ClubsRemoteDataSource());
    sl.registerLazySingleton<EventsRemoteDataSource>(() => EventsRemoteDataSource());

    // TODO: Implementation Repository Instance
    sl.registerLazySingleton<LayoutRemoteImplyRepository>(() => LayoutRemoteImplyRepository(layoutRemoteDataSource: sl(), clubsRemoteDataSource: sl(),eventsRemoteDataSource: sl()));

    sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

    sl.registerLazySingleton<AuthRemoteImplyRepository>(() => AuthRemoteImplyRepository(authRemoteDataSource: sl()));

  }
}