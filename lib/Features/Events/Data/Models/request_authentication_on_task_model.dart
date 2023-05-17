import '../../Domain/Entities/request_authentication_on_task_entity.dart';

class RequestAuthenticationOnATaskModel extends RequestAuthenticationOnATaskEntity{
  const RequestAuthenticationOnATaskModel(super.senderID, super.senderName);

  factory RequestAuthenticationOnATaskModel.fromJson({required json}) => RequestAuthenticationOnATaskModel(json['senderID'], json['senderName']);

  Map<String,dynamic> toJson(){
    return {
      'senderID' : super.senderID,
      'senderName' : super.senderName,
    };
  }

}