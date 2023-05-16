import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? name;
  final String? id;
  final String? email;
  final String? role;
  final String? password;
  final String? gender;
  final String? college;
  final int? phone;
  final List? idForEventsJoined;  // TODO: ID For Events That I have joined to it.
  final bool? isALeader;
  final String? idForClubLead;           // ID بتاع النادي اللي هو قائد عليه
  final String? membershipStartDate;
  final int? volunteerHoursNumber;
  final List? committeesName;    // اسم اللجنة اللي هو اختارها اما جه يعمل انضمام لنادي ك عضو
  final List? idForClubsMemberIn;   // TODO: ID for Clubs that i'm a Member in .....

  const UserEntity(this.name, this.id,this.idForClubLead, this.email, this.role, this.password, this.gender, this.college, this.phone,this.idForEventsJoined,this.isALeader,this.committeesName,this.membershipStartDate,this.volunteerHoursNumber,this.idForClubsMemberIn);

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,idForClubLead,email,role,password,gender,college,phone,idForEventsJoined,isALeader,committeesName,membershipStartDate,volunteerHoursNumber,idForClubsMemberIn];
}