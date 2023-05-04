import 'package:equatable/equatable.dart';

class RequestMembershipEntity extends Equatable {
  final String? userAskForMembershipID;
  final String? infoAboutAsker;
  final String? committeeName;
  final String? requestUserName;

  const RequestMembershipEntity(this.userAskForMembershipID, this.infoAboutAsker,this.committeeName,this.requestUserName);

  @override
  // TODO: implement props
  List<Object?> get props => [userAskForMembershipID,infoAboutAsker,committeeName,requestUserName];
}