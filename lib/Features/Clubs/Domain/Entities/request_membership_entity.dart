import 'package:equatable/equatable.dart';

class RequestMembershipEntity extends Equatable {
  final String senderID;
  final String infoAboutSender;
  final String committeeName;
  final String senderName;
  final String senderFirebaseFCMToken;

  const RequestMembershipEntity(this.senderID, this.infoAboutSender,this.committeeName,this.senderName,this.senderFirebaseFCMToken);

  @override
  // TODO: implement props
  List<Object?> get props => [senderID,infoAboutSender,committeeName,senderName,senderFirebaseFCMToken];
}