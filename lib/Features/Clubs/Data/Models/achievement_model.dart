import '../../Domain/Entities/achievement_entity.dart';

class AchievementModel extends Achievement{
  // Todo: Extend From Achievement Entity

  const AchievementModel({
    required super.totalHours,
    required super.eventsNum,
    required super.membersOfMonth,
    required super.clubID,
    required super.clubName
  });

  // Todo: From JSON to Refactor Data That come from Firestore
  factory AchievementModel.fromJson({required Map<String,dynamic> json})
  {
    return AchievementModel(
        totalHours: json['totalHours'],
        eventsNum:json['eventsNum'],
        membersOfMonth: json['membersOfMonth'],
        clubID: json['clubID'],
        clubName: json['clubName']
    );
  }

  // Todo: Send Data to Firebase
  Map<String,dynamic> toJson(){
    return {
      'totalHours' : totalHours,
      'eventsNum' : eventsNum,
      'membersOfMonth' : membersOfMonth,
      'clubID' : clubID,
      'clubName' : clubName,
    };
  }
}