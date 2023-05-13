import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import '../../Features/Auth/Presentation/Controller/auth_cubit.dart';
import '../../Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../Features/Events/Presentation/Controller/events_cubit.dart';
import '../../Features/Layout/Presentation/Controller/layout_cubit.dart';

class Constants{
  static dynamic providers = [
    BlocProvider(create: (context) => AuthCubit()),
    BlocProvider(create: (context) => ClubsCubit()),
    BlocProvider(create: (context) => EventsCubit()),
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
  static String kMeetingsCollectionName = "Meeting";
  static String kMembershipRequestsCollectionName = "Membership Requests";
  static String kMembersDataCollectionName = "Members Data";
  static String kMembersNumberCollectionName = "Members Number";
  static String kEventsCollectionName = "Events";
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
}