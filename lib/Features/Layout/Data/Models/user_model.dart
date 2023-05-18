import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(super.name, super.id,super.idForClubLead, super.email, super.role, super.password, super.gender, super.college, super.phone,super.idForEventsJoined,super.idForTasksAuthenticate,super.isALeader,super.committeesName,super.membershipStartDate,super.volunteerHours,super.idForClubsMemberIn);

  factory UserModel.fromJson({required json}) {
    return UserModel(json['name'], json['id'],json['idForClubLead'], json['email'], json['role'], json['password'], json['gender'], json['college'], json['phone'], json['idForEventsJoined'], json['idForTasksAuthenticate'],json['isALeader'],json['committeesName'],json['membershipStartDate'],json['volunteerHours'],json['idForClubsMemberIn']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'email' : super.email,
      'password' : super.password,
      'college' : super.college,
      'role' : super.role,
      'gender' : super.gender,
      'phone' : super.phone,
      'id' : super.id,
      'idForClubLead' : super.idForClubLead,
      'idForTasksAuthenticate' : super.idForTasksAuthenticate,
      'idForEventsJoined' : super.idForEventsJoined,
      'isALeader' : super.isALeader,
      'membershipStartDate' : super.membershipStartDate,
      'committeesName' : super.committeesName,
      'volunteerHours' : super.volunteerHours,
      'idForClubsMemberIn' : super.idForClubsMemberIn,
    };
  }

}