import 'package:bader_user_app/Features/Clubs/Data/Models/club_model.dart';
import 'package:equatable/equatable.dart';

class ClubEntity extends Equatable{
  final String? name;
  final int? id;
  final String? description;
  final String? image;
  final String? leaderEmail;
  final String? leaderID;
  final String? leaderName;
  final String? college;
  final List? committees;
  final int? memberNum;
  final int? volunteerHours;
  final int? currentEventsNum;
  final int? numOfRegisteredMembers;
  final ContactMeansForClubModel? contactAccounts;
  final bool isAvailable;  // TODO: Mean to apply | joining from Users
  final List availableOnlyForThisCollege;

  const ClubEntity(
      this.name,
      this.id,
      this.description,
      this.image,
      this.leaderEmail,
      this.leaderID,
      this.leaderName,
      this.college,
      this.committees,
      this.memberNum,
      this.volunteerHours,
      this.currentEventsNum,
      this.numOfRegisteredMembers,
      this.contactAccounts,
      this.isAvailable,
      this.availableOnlyForThisCollege
      ); // Todo: Mean Leader Gmail

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,description,image,leaderName,leaderID,leaderEmail,college,committees,memberNum,volunteerHours,currentEventsNum,numOfRegisteredMembers,contactAccounts,isAvailable,availableOnlyForThisCollege];

}

class ContactMeansForClub{
  final String? email;
  final String? twitter;

  ContactMeansForClub({required this.email,required this.twitter});
}