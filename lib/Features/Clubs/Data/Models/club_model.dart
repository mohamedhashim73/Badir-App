import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';

class ClubModel extends ClubEntity{

  const ClubModel(super.name, super.id, super.description, super.image, super.leaderEmail, super.leaderID, super.leaderName, super.college, super.committees, super.memberNum, super.contactAccounts);

  factory ClubModel.fromJson({required json})
  {
    return ClubModel(json['name'], json['id'], json['description'], json['image'], json['leaderEmail'], json['leaderID'], json['leaderName'], json['college'], json['committees'], json['memberNum'], json['contactAccounts']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'id' : super.id,
      'description' : super.description,
      'image' : super.image,
      'leaderEmail' : super.leaderEmail,
      'leaderID' : super.leaderID,
      'college' : super.college,
      'leaderName' : super.leaderName,
      'committees' : super.committees,
      'memberNum' : super.memberNum,
      'contactAccounts' : super.contactAccounts,
    };
  }

}