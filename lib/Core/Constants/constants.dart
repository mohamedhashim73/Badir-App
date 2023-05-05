import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import '../../Features/Auth/Presentation/Controller/auth_cubit.dart';
import '../../Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../Features/Events/Presentation/Controller/events_cubit.dart';
import '../../Features/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';

class Constants{
  static dynamic providers = [
    BlocProvider(create: (context) => AuthCubit()),
    BlocProvider(create: (context) => ClubsCubit()),
    BlocProvider(create: (context) => EventsCubit()),
    BlocProvider(create: (context) => LayoutCubit()..getMyData()),
  ];
  static String? userID;
  static List<String> colleges = ["كليه حاسبات ومعلومات","كليه هندسه","كليه صيدله","كليه تمريض","كليه طب","كليه تربيه رياضيه"];
  static List<String> committees = ["العلمية","الرياضية","الفنية"];
  static List<String> genderStatus = ["ذكر","أنثي"];
  static String kNotificationsCollectionName = "Notifications";
  static String kUsersCollectionName = "Users";
  static String kClubsCollectionName = "Clubs";
  static String kMembershipRequestsCollectionName = "Membership Requests";
  static String kMembersDataCollectionName = "Members Data";
  static String kMembersNumberCollectionName = "Members Number";
  static String kEventsCollectionName = "Events";
  static String kReportsCollectionName = "Reports";
  static String getTimeNow() => Jiffy(DateTime.now()).yMMMd;
}