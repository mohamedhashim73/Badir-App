import 'package:bader_user_app/Features/Clubs/Domain/Entities/member_entity.dart';

class MemberModel extends MemberEntity{
  // Todo: Extend From Achievement Entity

  const MemberModel({
    required super.memberName,
    required super.memberID,
    required super.membershipDate,
  });

  // Todo: From JSON to Refactor Data That come from Firestore
  factory MemberModel.fromJson({required Map<String,dynamic> json})
  {
    return MemberModel(
        memberName: json['memberName'],
        memberID: json['memberID'],
        membershipDate:json['membershipDate'],
    );
  }

  // Todo: Send Data to Firebase
  Map<String,dynamic> toJson(){
    return {
      'memberName' : memberName,
      'memberID' : memberID,
      'membershipDate' : membershipDate,
    };
  }
}