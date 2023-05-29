import 'dart:io';
import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/local_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Data/Data_Sources/remote_clubs_data_source.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Contract_Repositories/club_contract_repository.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../Layout/Domain/Entities/user_entity.dart';
import '../../Domain/Entities/request_membership_entity.dart';
import '../Models/club_model.dart';
import '../Models/meeting_model.dart';

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
  Future<Either<Failure,Set<String>>> getMembersOnMyClub({required String idForClubILead}) async {
    try
    {
      return Right(await remoteClubsDataSource.getMembersOnMyClub(clubID: idForClubILead));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<bool> requestAMembershipOnSpecificClub({required String senderFirebaseFCMToken,required String clubID, required String requestUserName, required String userAskForMembershipID, required String infoAboutAsker, required String committeeName}) async {
    return remoteClubsDataSource.requestAMembershipOnSpecificClub(senderFirebaseFCMToken:senderFirebaseFCMToken,clubID: clubID, requestUserName: requestUserName, userAskForMembershipID: userAskForMembershipID, infoAboutAsker: infoAboutAsker, committeeName: committeeName);
  }

  @override
  Future<Either<Failure, String>> uploadClubImageToStorage({required File imgFile}) async {
    try
    {
      String imageUrl = await remoteClubsDataSource.uploadClubImageToStorage(imgFile: imgFile);
      return Right(imageUrl);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
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
  Future<Either<Failure,Unit>> createMeeting({required String idForClubILead,required String name,required String description,required String date,required String time,required String location,required String link}) async {
    try
    {
      return Right(await remoteClubsDataSource.createMeeting(idForClubILead: idForClubILead, name: name, description: description, date: date, time: time, location: location, link: link));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,UserEntity>> getMemberData({required String memberID}) async {
    try
    {
      return Right(await remoteClubsDataSource.getMemberData(memberID: memberID));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<MeetingModel>>> getMeetingCreatedByMe({required String clubID}) async {
    try
    {
      return Right(await remoteClubsDataSource.getMeetingCreatedByMe(clubID: clubID));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<MeetingModel>>> getMeetingRelatedToClubIMemberIn({required List idForClubsMemberIn}) async {
    try
    {
      return Right(await remoteClubsDataSource.getMeetingRelatedToClubIMemberIn(idForClubsMemberIn: idForClubsMemberIn));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> deleteMeeting({required String meetingID,required String clubID}) async {
    try
    {
      return Right(await remoteClubsDataSource.deleteMeeting(clubID: clubID,meetingID: meetingID));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptOrRejectMembershipRequest({required String committeeNameForRequestSender,required String requestSenderID, required String clubID, required bool respondStatus}) async {
    try
    {
      final clubs = await remoteClubsDataSource.acceptOrRejectMembershipRequest(committeeNameForRequestSender: committeeNameForRequestSender,requestSenderID: requestSenderID, clubID: clubID, respondStatus: respondStatus);
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

  @override
  Future<Either<Failure,Unit>> updateClubAvailability({required String clubID,required bool isAvailable,required List availableOnlyForThisCollege}) async {
    try
    {
      return Right(await remoteClubsDataSource.updateClubAvailability(clubID: clubID, isAvailable: isAvailable, availableOnlyForThisCollege: availableOnlyForThisCollege));
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Set>> getIDForClubsIAskedForMembership({List? idForClubsMemberID,required String userID}) async {
    try
    {
      return Right(await remoteClubsDataSource.getIDForClubsIAskedForMembership(userID: userID,idForClubsMemberID: idForClubsMemberID));
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeMemberFromClubILead({required String memberID, required String clubID}) async {
    try
    {
      return Right(await remoteClubsDataSource.removeMemberFromClubILead(memberID: memberID, clubID: clubID));
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

}