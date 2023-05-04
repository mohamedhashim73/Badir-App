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
  final bool? isALeader;
  final String? clubIDThatHeLead;           // ID بتاع النادي اللي هو قائد عليه
  final String? membershipStartDate;
  final int? volunteerHoursNumber;
  final String? committeeName;    // اسم اللجنة اللي هو اختارها اما جه يعمل انضمام لنادي ك عضو

  const UserEntity(this.name, this.id,this.clubIDThatHeLead, this.email, this.role, this.password, this.gender, this.college, this.phone,this.isALeader,this.committeeName,this.membershipStartDate,this.volunteerHoursNumber);

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,clubIDThatHeLead,email,role,password,gender,college,phone,isALeader,committeeName,membershipStartDate,volunteerHoursNumber];
}