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
  final ContactMeansForClubModel? contactAccounts;

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
      this.contactAccounts); // Todo: Mean Leader Gmail

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,description,image,leaderName,leaderID,leaderEmail,college,committees,memberNum,contactAccounts];

}

class ContactMeansForClub{
  final String? phone;
  final String? twitter;

  ContactMeansForClub({required this.phone,required this.twitter});
}