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

  const UserEntity(this.name, this.id, this.email, this.role, this.password, this.gender, this.college, this.phone,this.isALeader);

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,email,role,password,gender,college,phone,isALeader];
}