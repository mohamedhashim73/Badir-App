import 'dart:io';

import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/local_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/remote_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Contract_Repositories/club_contract_repository.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Domain/Entities/request_membership_entity.dart';
import '../Models/club_model.dart';

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
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID}) {
    // TODO: implement viewClubMembersInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> requestAMembershipOnSpecificClub({required String clubID, required String requestUserName, required String userAskForMembershipID, required String infoAboutAsker, required String committeeName}) async {
    return remoteClubsDataSource.requestAMembershipOnSpecificClub(clubID: clubID, requestUserName: requestUserName, userAskForMembershipID: userAskForMembershipID, infoAboutAsker: infoAboutAsker, committeeName: committeeName);
  }

  @override
  Future<Either<Failure, String>> uploadClubImageToStorage({required File imgFile}) async {
    try
    {
      String imageUrl = await remoteClubsDataSource.uploadClubImageToStorage(imgFile: imgFile);
      return Right(imageUrl);
    }
    on NoNetworkException catch(e){
      return Left(NoNetworkFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateClubData({required String clubID, required String image, required String name, required int memberNum, required String aboutClub, required ContactMeansForClubModel contactInfo}) async {
    try
    {
      await remoteClubsDataSource.updateClubData(clubID: clubID, image: image, name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactInfo);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptOrRejectMembershipRequest({required String requestSenderID, required String clubID, required bool respondStatus}) async {
    try
    {
      final clubs = await remoteClubsDataSource.acceptOrRejectMembershipRequest(requestSenderID: requestSenderID, clubID: clubID, respondStatus: respondStatus);
      return const Right(unit);
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<RequestMembershipEntity>>> getMembershipRequests({required String clubID}) async {
    try
    {
      final requests = await remoteClubsDataSource.getMembershipRequests(clubID: clubID);
      return Right(requests);
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

}