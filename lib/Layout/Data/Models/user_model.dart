import 'package:bader_user_app/Layout/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(super.name, super.id, super.email, super.role, super.password, super.gender, super.college, super.phone,super.isALeader);

  factory UserModel.fromJson({required json}) {
    return UserModel(json['name'], json['id'], json['email'], json['role'], json['password'], json['gender'], json['college'], json['phone'],json['isALeader']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'email' : super.email,
      'password' : super.password,
      'role' : super.role,
      'gender' : super.gender,
      'phone' : super.phone,
      'id' : super.id,
      'isALeader' : super.isALeader,
    };
  }

}