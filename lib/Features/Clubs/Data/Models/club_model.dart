import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';

class ClubModel extends ClubEntity{

  const ClubModel(super.name, super.id, super.description, super.image, super.leaderEmail, super.leaderID, super.leaderName, super.college, super.committees, super.memberNum, super.contactAccounts);

  factory ClubModel.fromJson({required json})
  {
    return ClubModel(json['name'], json['id'], json['description'], json['image'], json['leaderEmail'], json['leaderID'], json['leaderName'], json['college'], json['committees'], json['memberNum'], ContactMeansForClubModel.fromJson(json: json['contactAccounts']));
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
      'contactAccounts' : super.contactAccounts.toJson(),
    };
  }

}

class ContactMeansForClubModel extends ContactMeansForClub{
  ContactMeansForClubModel({required super.phone, required super.twitter});

  factory ContactMeansForClubModel.fromJson({required Map<String,dynamic> json}) => ContactMeansForClubModel(phone: json['phone'], twitter: json['twitter']);

  Map<String,dynamic> toJson(){
    return {
      'phone' : super.phone,
      'twitter' : super.twitter,
    };
  }

}