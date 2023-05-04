import 'package:dartz/dartz.dart';
import '../../../../Core/Errors/failure.dart';
import '../../../Layout/Domain/Entities/user_entity.dart';
import '../Entities/club_entity.dart';

abstract class ClubsContractRepository{

  Future<Either<Failure,List<ClubEntity>>> getClubs();

  // TODO: CLUBS -- LEADER ROLE
  Future<bool> addClub({required Map<String,dynamic> toJson});
  Future<bool> editClub({required String clubID});
  Future<bool> deleteClub({required String clubID});

  // TODO: ACCEPT OR REFUSE MEMBERSHIP REQUEST -- LEADER ROLE
  Future<bool> acceptOrRefuseMembershipRequest({required String requestSenderID});
  Future<bool> deleteMemberFromClub({required String memberID});
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID});

  // TODO: Invitation to be a member on Specific Club ( Public Member, Leader on this club will be accept or refuse )
  Future<bool> requestAMembershipOnSpecificClub({required String clubID,required String requestUserName,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName});

}