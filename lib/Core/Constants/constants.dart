import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import '../../Features/Auth/Presentation/Controller/auth_cubit.dart';
import '../../Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../Features/Events/Domain/Entities/event_entity.dart';
import '../../Features/Events/Presentation/Controller/events_cubit.dart';
import '../../Features/Layout/Presentation/Controller/layout_cubit.dart';

class Constants {
  static dynamic providers = [
    BlocProvider(create: (context) => AuthCubit()),
    BlocProvider(create: (context) => ClubsCubit()),
    BlocProvider(create: (context) => EventsCubit()..getAllTasksOnApp()),
    BlocProvider(create: (context) => LayoutCubit()..getMyData()),
  ];
  static String? userID;
  static List<String> colleges = ["كليه حاسبات ومعلومات","كليه هندسه","كليه صيدله","كليه تمريض","كليه طب","كليه تربيه رياضيه"];
  static List<String> reportTypes = ["خطة سنوية","فعالية","ساعات تطوعية"];
  static List<String> committees = ["العلمية","الرياضية","الفنية"];
  static List<String> genderStatus = ["ذكر","أنثي"];
  static String kNotificationsCollectionName = "Notifications";
  static String kUsersCollectionName = "Users";
  static String kClubsCollectionName = "Clubs";
  static String kMeetingsCollectionName = "Meetings";
  static String kMembershipRequestsCollectionName = "Membership Requests";
  static String kTaskAuthenticationRequestsCollectionName = "Tasks Authentication Requests";
  static String kMembersDataCollectionName = "Members Data";
  static String kMembersNumberCollectionName = "Members Number";
  static String kTotalVolunteerHoursThrowAppCollectionName = "Volunteer Hours";
  static String kEventsCollectionName = "Events";
  static String kTasksCollectionName = "Tasks";
  static String kReportsCollectionName = "Reports";
  static String getTimeNow() => Jiffy(DateTime.now()).yMMMd;
  static Future<TimeOfDay?> selectTime({required BuildContext context}) async => await showTimePicker(context: context,initialTime: TimeOfDay.now());
  static Future<DateTime?> selectDate({required BuildContext context}) async => await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  static Future<XFile?> getImageFromGallery() async => await ImagePicker().pickImage(source: ImageSource.gallery);

  // TODO: هستخدمهم في عرض بيانات الفعاليه عشان بناء عليها هعمل action معين
  static bool eventExpiredAndIHaveNotJoined({required UserEntity userEntity,required bool eventDateExpired,required String eventID}){
    return eventDateExpired && (userEntity.idForEventsJoined == null || (userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(eventID) == false));
  }
  static bool eventInDateAndIDoNotHavePermissionToJoin({required bool eventForOnlyMembers,required UserEntity userEntity,required bool eventDateExpired,required String eventID,required String clubID}){
    return eventForOnlyMembers && !eventDateExpired && (userEntity.idForClubsMemberIn == null || (userEntity.idForClubsMemberIn != null && userEntity.idForClubsMemberIn!.contains(clubID) == false));
  }
  static bool eventExpiredAndIHaveJoined({required UserEntity userEntity,required bool eventDateExpired,required String eventID}){
    return eventDateExpired && (userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(eventID) == false);
  }
  static bool eventInDateAndIHaveJoined({required UserEntity userEntity,required bool eventDateExpired,required String eventID}){
    return !eventDateExpired && (userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(eventID));
  }
  static bool eventInDateAndIHaveNotJoinedYetAndHavePermission({required bool eventForOnlyMembers,required UserEntity userEntity,required bool eventDateExpired,required String eventID,required String clubID}){
    return (!eventForOnlyMembers && !eventDateExpired && (userEntity.idForEventsJoined == null || (userEntity.idForEventsJoined!.contains(eventID) == false))) && (!eventDateExpired && ((userEntity.idForClubsMemberIn != null && userEntity.idForClubsMemberIn!.contains(clubID) == true)));
  }
}