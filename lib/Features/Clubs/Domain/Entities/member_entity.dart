import 'package:equatable/equatable.dart';

class MemberEntity extends Equatable{
  final String memberID;
  final String memberName;
  final String membershipDate;

  const MemberEntity({required this.memberName,required this.memberID, required this.membershipDate});

  @override
  // TODO: implement props
  List<Object?> get props => [memberName,membershipDate,memberID];
}