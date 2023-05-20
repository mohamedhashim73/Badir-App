import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';

class ClubModel extends ClubEntity{

  const ClubModel(super.name, super.id, super.description, super.image, super.leaderEmail, super.leaderID, super.leaderName, super.college, super.committees, super.memberNum,super.volunteerHours,super.currentEventsNum,super.numOfRegisteredMembers, super.contactAccounts, super.isAvailable, super.availableOnlyForThisCollege);

  factory ClubModel.fromJson({required json})
  {
    return ClubModel(json['name'], json['id'], json['description'], json['image'], json['leaderEmail'], json['leaderID'], json['leaderName'], json['college'], json['committees'], json['memberNum'],json['volunteerHours'],json['currentEventsNum'],json['numOfRegisteredMembers'], json['contactAccounts'] != null ? ContactMeansForClubModel.fromJson(json: json['contactAccounts']) : null,json['isAvailable'],json['availableOnlyForThisCollege']);
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
      'availableOnlyForThisCollege' : super.availableOnlyForThisCollege,
      'isAvailable' : super.isAvailable,
      'committees' : super.committees,
      'memberNum' : super.memberNum,
      'volunteerHours' : super.volunteerHours,
      'currentEventsNum' : super.currentEventsNum,
      'numOfRegisteredMembers' : super.numOfRegisteredMembers,
      'contactAccounts' : super.contactAccounts != null ? super.contactAccounts!.toJson() : null,
    };
  }

}

class ContactMeansForClubModel extends ContactMeansForClub{
  ContactMeansForClubModel({required super.email, required super.twitter});

  factory ContactMeansForClubModel.fromJson({required Map<String,dynamic> json}) => ContactMeansForClubModel(email: json['email'], twitter: json['twitter']);

  Map<String,dynamic> toJson(){
    return {
      'email' : super.email,
      'twitter' : super.twitter,
    };
  }

}