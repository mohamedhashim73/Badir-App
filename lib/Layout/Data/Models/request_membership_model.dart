import 'package:bader_user_app/Layout/Domain/Entities/request_membership_entity.dart';

class RequestMembershipModel extends RequestMembershipEntity{
  const RequestMembershipModel(super.userAskForMembershipID, super.infoAboutAsker,super.committeeName,super.requestUserName);

  factory RequestMembershipModel.fromJson({required json}) => RequestMembershipModel(json['userAskForMembershipID'], json['infoAboutAsker'],json['committeeName'],json['requestUserName']);

  Map<String,dynamic> toJson(){
    return {
      'userAskForMembershipID' : super.userAskForMembershipID,
      'infoAboutAsker' : super.infoAboutAsker,
      'committeeName' : super.committeeName,
      'requestUserName' : super.requestUserName,
    };
  }
}