import 'package:bader_user_app/Features/Clubs/Data/Models/club_model.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/request_membership_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Errors/failure.dart';
import '../../../Layout/Domain/Entities/user_entity.dart';
import '../Entities/club_entity.dart';
import 'dart:io';

abstract class ClubsContractRepository{

  Future<Either<Failure,List<ClubEntity>>> getClubs();

  // TODO: CLUBS -- LEADER ROLE
  Future<Either<Failure,String>> uploadClubImageToStorage({required File imgFile});
  // Unit replace void role
  Future<Either<Failure,Unit>> updateClubData({required String clubID,required String image,required String name,required int memberNum,required String aboutClub,required ContactMeansForClubModel contactInfo});
  Future<bool> deleteClub({required String clubID});

  // TODO: ACCEPT OR REFUSE MEMBERSHIP REQUEST -- LEADER ROLE
  Future<Either<Failure,Unit>> acceptOrRejectMembershipRequest({required String requestSenderID,required String clubID,required bool respondStatus});
  Future<bool> deleteMemberFromClub({required String memberID});
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID});

  // TODO: Invitation to be a member on Specific Club ( Public Member, Leader on this club will be accept or refuse )
  Future<bool> requestAMembershipOnSpecificClub({required String clubID,required String requestUserName,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName});
  Future<Either<Failure,List<RequestMembershipEntity>>> getMembershipRequests({required String clubID});

}