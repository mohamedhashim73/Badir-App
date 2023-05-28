import 'package:bader_user_app/Features/Auth/Data/Data_Source/auth_data_source.dart';
import 'package:bader_user_app/Features/Auth/Data/Repositories/auth_remote_repository.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/login_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/local_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/remote_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Imply_Repositories/clubs_imply_repository.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/accept_or_reject_membership_request_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/create_meeting_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_all_clubs_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_meetings_created_by_me_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_member_data_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/remove_member_from_club_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/update_club_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/delete_event_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_all_events_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_id_for_tasks_that_i_asked_for_authentication.dart';
import 'package:bader_user_app/Features/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Features/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/log_out_use_case.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/send_notification.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/upload_image_to_storage_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../../Features/Auth/Domain/UseCases/register_use_case.dart';
import '../../Features/Auth/Domain/UseCases/update_firebase_messaging_token_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/delete_meeting_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/get_all_membership_requests_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/get_id_for_clubs_that_i_ask_for_membershi_waiting_result_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/get_meetings_for_club_member_in_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/get_members_on_my_club_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/request_membership_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/update_availability_for_club_use_case.dart';
import '../../Features/Clubs/Domain/Use_Cases/upload_image_to_storage_use_case.dart';
import '../../Features/Events/Data/Data_Sources/local_events_data_source.dart';
import '../../Features/Events/Data/Data_Sources/remote_events_data_source.dart';
import '../../Features/Events/Data/Imply_Repositories/events_imply_repository.dart';
import '../../Features/Events/Domain/Use_Cases/accept_or_reject_user_request_to_authenticate_on_task_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/add_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/create_task_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/delete_task_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/get_all_tasks_on_app_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/get_members_on_an_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/get_opinions_about_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/get_requests_for_authentication_on_task_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/join_to_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/request_authenticate_on_task_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/send_opinion_about_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/update_event_use_case.dart';
import '../../Features/Events/Domain/Use_Cases/update_task_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/get_all_users_on_app_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/get_my_data_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/get_notifications_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/update_my_data_use_case.dart';
import '../../Features/Layout/Domain/Use Cases/upload_report_to_admin_use_case.dart';

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

    sl.registerLazySingleton<AuthImplyRepository>(() => AuthImplyRepository(authRemoteDataSource: sl()));


    // TODO: USE CASES ......

    // Auth USE CASES
    sl.registerLazySingleton<UpdateMyFirebaseMessagingTokenUseCase>(() => UpdateMyFirebaseMessagingTokenUseCase(authBaseRepository: sl<AuthImplyRepository>()));
    sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(authBaseRepository: sl<AuthImplyRepository>()));
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(authBaseRepository: sl<AuthImplyRepository>()));

    // CLUBS USE CASES
    sl.registerLazySingleton<RequestAMembershipUseCase>(() => RequestAMembershipUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMembersDataOnMyClubUseCase>(() => GetMembersDataOnMyClubUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<UpdateClubAvailabilityUseCase>(() => UpdateClubAvailabilityUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetAllClubsUseCase>(() => GetAllClubsUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetIDForClubsIAskedForMembershipUseCase>(() => GetIDForClubsIAskedForMembershipUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<UploadClubImageToStorageUseCase>(() => UploadClubImageToStorageUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<UpdateClubUseCase>(() => UpdateClubUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<CreateMeetingUseCase>(() => CreateMeetingUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<RemoveMemberFromClubILeadUseCase>(() => RemoveMemberFromClubILeadUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<DeleteMeetingUseCase>(() => DeleteMeetingUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMeetingRelatedToClubIMemberInUseCase>(() => GetMeetingRelatedToClubIMemberInUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMeetingsCreatedByMeUseCase>(() => GetMeetingsCreatedByMeUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<AcceptOrRejectMembershipRequestUseCase>(() => AcceptOrRejectMembershipRequestUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMemberDataUseCase>(() => GetMemberDataUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));
    sl.registerLazySingleton<GetMembershipRequestsUseCase>(() => GetMembershipRequestsUseCase(clubsContractRepository: sl<ClubsImplyRepository>()));

    // EVENTS USE CASE
    sl.registerLazySingleton<GetAllEventsUseCase>(() => GetAllEventsUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<UpdateEventUseCase>(() => UpdateEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<DeleteEventUseCase>(() => DeleteEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<GedRequestForAuthenticateOnATaskUseCase>(() => GedRequestForAuthenticateOnATaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<GetIDForTasksThatIAskedForAuthenticationBeforeUseCase>(() => GetIDForTasksThatIAskedForAuthenticationBeforeUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<GetAllTasksOnAppUseCase>(() => GetAllTasksOnAppUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<CreateEventUseCase>(() => CreateEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<RequestAuthenticationOnATaskUseCase>(() => RequestAuthenticationOnATaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<AcceptOrRejectAuthenticateRequestOnATaskUseCase>(() => AcceptOrRejectAuthenticateRequestOnATaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<UpdateTaskUseCase>(() => UpdateTaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<GetOpinionsAboutEventUseCase>(() => GetOpinionsAboutEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<JoinToEventUseCase>(() => JoinToEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<CreateTaskUseCase>(() => CreateTaskUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<SendOpinionAboutEventUseCase>(() => SendOpinionAboutEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));
    sl.registerLazySingleton<GetMembersOnAnEventUseCase>(() => GetMembersOnAnEventUseCase(eventsContractRepository: sl<EventsImplyRepository>()));

    // LAYOUT USE CASES
    sl.registerLazySingleton<UpdateMyDataUseCase>(() => UpdateMyDataUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<UploadReportToAdminUseCase>(() => UploadReportToAdminUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<GetAllUsersOnAppUseCase>(() => GetAllUsersOnAppUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<UploadImageToStorageUseCase>(() => UploadImageToStorageUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<LogOutUseCase>(() => LogOutUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<GetMyDataUseCase>(() => GetMyDataUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<SendNotificationUseCase>(() => SendNotificationUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));
    sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(layoutBaseRepository: sl<LayoutImplyRepository>()));

  }
}