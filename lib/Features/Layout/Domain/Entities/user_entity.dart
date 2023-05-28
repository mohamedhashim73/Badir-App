import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? name;
  final String? id;
  final String? firebaseMessagingToken;
  final String? email;
  final String? role;
  final String? password;
  final String? gender;
  final String? college;
  final int? phone;
  final List? idForEventsJoined;  // TODO: ID For Events That I have joined to it.
  final List? idForTasksAuthenticate;  // TODO: ID For Tasks That I have authenticated to it.
  final bool? isALeader;
  final String? idForClubLead;           // ID بتاع النادي اللي هو قائد عليه
  final String? membershipStartDate;
  final int? volunteerHours;
  final List? committeesNames;    // اسم اللجنة اللي هو اختارها اما جه يعمل انضمام لنادي ك عضو
  final List? idForClubsMemberIn;   // TODO: ID for Clubs that i'm a Member in .....

  const UserEntity(this.name, this.id,this.firebaseMessagingToken,this.idForClubLead, this.email, this.role, this.password, this.gender, this.college, this.phone,this.idForEventsJoined,this.idForTasksAuthenticate,this.isALeader,this.committeesNames,this.membershipStartDate,this.volunteerHours,this.idForClubsMemberIn);

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,firebaseMessagingToken,idForClubLead,email,role,password,gender,college,phone,idForEventsJoined,idForTasksAuthenticate,isALeader,committeesNames,membershipStartDate,volunteerHours,idForClubsMemberIn];
}