import 'package:bader_user_app/Features/Auth/Data/Data_Source/auth_data_source.dart';
import 'package:bader_user_app/Features/Auth/Data/Repositories/auth_remote_repository.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/local_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/remote_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Imply_Repositories/clubs_imply_repository.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/accept_or_reject_membership_request_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_all_clubs_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/update_club_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_all_events_use_case.dart';
import 'package:bader_user_app/Features/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Features/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/send_notification.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/upload_image_to_storage_use_case.dart';
import 'package:get_it/get_it.dart';
import '../../Features/Clubs/Domain/Use_Cases/get_all_membership_requests_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/request_membership_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/upload_image_to_storage_use_case.dart';
import '../../Features/Events/Data/Data_Sources/local_events_data_source.dart';
import '../../Features/Events/Data/Data_Sources/remote_events_data_source.dart';
import '../../Features/Events/Data/Imply_Repositories/events_imply_repository.dart';
import '../../Features/Events/Domain/Use_Cases/add_event_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/get_my_data_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/get_notifications_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/update_my_data_use_case.dart';

final GetIt sl = GetIt.instance;

class ServiceLocators{
  // TODO: Make Object from Classes That I want be created
  static Future<void> serviceLocatorInitialization() async {

    // TODO: Data Source Instance ......
    // LAYOUT DATA SOURCE
    sl.registerLazySingleton<LayoutRemoteDataSource>(() => LayoutRemoteDataSource());

    // CLUBS DATA SOURCE
    sl.registerLazySingleton<RemoteClubsDataSource>(() => RemoteClubsDataSource());
    sl.registerLazySingleton<LocalClubsDataSource>(() => LocalClubsDataSource());

    // EVENTS DATA SOURCE
    sl.registerLazySingleton<RemoteEventsDataSource>(() => RemoteEventsDataSource());
    sl.registerLazySingleton<LocalEventsDataSource>(() => LocalEventsDataSource());

    // AUTH DATA SOURCE
    sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());


    // TODO: Implementation Repository Instance ......
    sl.registerLazySingleton<LayoutImplyRepository>(() => LayoutImplyRepository(layoutRemoteDataSource: sl()));

    sl.registerLazySingleton<ClubsImplyRepository>(() => ClubsImplyRepository(remoteClubsDataSource: sl(), localClubsDataSource: sl()));

    sl.registerLazySingleton<EventsImplyRepository>(() => EventsImplyRepository(remoteEventsDataSource: sl(), localEventsDataSource: sl()));

    sl.registerLazySingleton<AuthRemoteImplyRepository>(() => AuthRemoteImplyRepository(authRemoteDataSource: sl()));


    // TODO: USE CASES ......

    // CLUBS USE CASES
    sl.registerLazySingleton<RequestAMembershipUseCase>(() => RequestAMembershipUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetAllClubsUseCase>(() => GetAllClubsUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<UploadClubImageToStorageUseCase>(() => UploadClubImageToStorageUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<UpdateClubUseCase>(() => UpdateClubUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<AcceptOrRejectMembershipRequestUseCase>(() => AcceptOrRejectMembershipRequestUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMembershipRequestsUseCase>(() => GetMembershipRequestsUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));

    // EVENTS USE CASE
    sl.registerLazySingleton<GetAllEventsUseCase>(() => GetAllEventsUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<CreateEventUseCase>(() => CreateEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));

    // LAYOUT USE CASES
    sl.registerLazySingleton<UpdateMyDataUseCase>(() => UpdateMyDataUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<UploadImageToStorageUseCase>(() => UploadImageToStorageUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<GetMyDataUseCase>(() => GetMyDataUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<SendNotificationUseCase>(() => SendNotificationUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));

  }
}