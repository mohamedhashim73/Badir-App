import 'package:intl/intl.dart';

class Constants{
  static String? userID;
  static List<String> colleges = ["كليه حاسبات ومعلومات","كليه هندسه","كليه صيدله","كليه تمريض","كليه طب","كليه تربيه رياضيه"];
  static List<String> genderStatus = ["ذكر","أنثي"];
  static String kNotificationsCollectionName = "Notifications";
  static String kUsersCollectionName = "Users";
  static String kClubsCollectionName = "Clubs";
  static String kEventsCollectionName = "Events";
  static String kReportsCollectionName = "Reports";
  static String getTimeNow() => DateFormat('dd MMMM yyyy', 'ar').format(DateTime.now());
}