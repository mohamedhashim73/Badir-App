import 'package:equatable/equatable.dart';

class Achievement extends Equatable{
  final int totalHours;
  final int eventsNum;
  final int membersOfMonth;
  final String clubName;
  final String clubID;

  const Achievement({required this.totalHours, required this.eventsNum, required this.membersOfMonth, required this.clubID, required this.clubName});

  @override
  // TODO: implement props
  List<Object?> get props => [totalHours,eventsNum,membersOfMonth,clubName,clubID];
}