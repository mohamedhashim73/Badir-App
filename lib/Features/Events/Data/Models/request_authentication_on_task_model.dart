import '../../Domain/Entities/request_authentication_on_task_entity.dart';

class RequestAuthenticationOnATaskModel extends RequestAuthenticationOnATaskEntity{
  const RequestAuthenticationOnATaskModel(super.senderID,super.senderFirebaseFCMToken, super.senderName);

  factory RequestAuthenticationOnATaskModel.fromJson({required json}) => RequestAuthenticationOnATaskModel(json['senderID'],json['senderFirebaseFCMToken'], json['senderName']);

  Map<String,dynamic> toJson(){
    return {
      'senderID' : super.senderID,
      'senderFirebaseFCMToken' : super.senderFirebaseFCMToken,
      'senderName' : super.senderName,
    };
  }

}