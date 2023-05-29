import 'package:equatable/equatable.dart';

class RequestAuthenticationOnATaskEntity extends Equatable {
  final String senderID;
  final String senderFirebaseFCMToken;
  final String senderName;

  const RequestAuthenticationOnATaskEntity(this.senderID,this.senderFirebaseFCMToken, this.senderName);

  @override
  // TODO: implement props
  List<Object?> get props => [senderID,senderFirebaseFCMToken,senderName];
}