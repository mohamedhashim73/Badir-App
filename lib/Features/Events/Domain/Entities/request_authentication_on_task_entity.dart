import 'package:equatable/equatable.dart';

class RequestAuthenticationOnATaskEntity extends Equatable {
  final String? senderID;
  final String? senderName;

  const RequestAuthenticationOnATaskEntity(this.senderID, this.senderName);

  @override
  // TODO: implement props
  List<Object?> get props => [senderID,senderName];
}