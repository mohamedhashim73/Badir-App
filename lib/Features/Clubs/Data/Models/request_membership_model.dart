import 'package:bader_user_app/Features/Clubs/Domain/Entities/request_membership_entity.dart';

class RequestMembershipModel extends RequestMembershipEntity{
  const RequestMembershipModel(super.senderID, super.infoAboutSender,super.committeeName,super.senderName,super.senderFirebaseFCMToken);

  factory RequestMembershipModel.fromJson({required json}) => RequestMembershipModel(json['senderID'], json['infoAboutSender'],json['committeeName'],json['senderName'],json['senderFirebaseFCMToken']);

  Map<String,dynamic> toJson(){
    return {
      'senderID' : super.senderID,
      'infoAboutSender' : super.infoAboutSender,
      'committeeName' : super.committeeName,
      'senderName' : super.senderName,
      'senderFirebaseFCMToken' : super.senderFirebaseFCMToken,
    };
  }
}