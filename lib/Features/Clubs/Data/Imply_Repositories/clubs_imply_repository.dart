import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/local_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/remote_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Contract_Repositories/club_contract_repository.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:dartz/dartz.dart';

class ClubsImplyRepository implements ClubsContractRepository{
  final RemoteClubsDataSource remoteClubsDataSource;
  final LocalClubsDataSource localClubsDataSource;

  ClubsImplyRepository({required this.remoteClubsDataSource,required this.localClubsDataSource});

  @override
  Future<Either<Failure, List<ClubEntity>>> getClubs() async {
    try
    {
      final clubs = await remoteClubsDataSource.getAllClubs();
      return Right(clubs);
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<bool> acceptOrRefuseMembershipRequest({required String requestSenderID}) {
    // TODO: implement acceptOrRefuseMembershipRequest
    throw UnimplementedError();
  }

  @override
  Future<bool> addClub({required Map<String, dynamic> toJson}) {
    // TODO: implement addClub
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteClub({required String clubID}) {
    // TODO: implement deleteClub
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteMemberFromClub({required String memberID}) {
    // TODO: implement deleteMemberFromClub
    throw UnimplementedError();
  }

  @override
  Future<bool> editClub({required String clubID}) {
    // TODO: implement editClub
    throw UnimplementedError();
  }

  @override
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID}) {
    // TODO: implement viewClubMembersInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> requestAMembershipOnSpecificClub({required String clubID, required String requestUserName, required String userAskForMembershipID, required String infoAboutAsker, required String committeeName}) async {
    return remoteClubsDataSource.requestAMembershipOnSpecificClub(clubID: clubID, requestUserName: requestUserName, userAskForMembershipID: userAskForMembershipID, infoAboutAsker: infoAboutAsker, committeeName: committeeName);
  }

}