import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Layout/Data/Data_Source/clubs_remote_data_source.dart';
import 'package:bader_user_app/Layout/Data/Data_Source/events_remote_data_source.dart';
import 'package:bader_user_app/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Layout/Data/Models/club_model.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/notification_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class LayoutRemoteImplyRepository implements LayoutBaseRepository {
  final LayoutRemoteDataSource layoutRemoteDataSource;
  final ClubsRemoteDataSource clubsRemoteDataSource;
  final EventsRemoteDataSource eventsRemoteDataSource;
  LayoutRemoteImplyRepository({required this.layoutRemoteDataSource,required this.clubsRemoteDataSource,required this.eventsRemoteDataSource});

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
  Future<bool> addEvent({required Map<String, dynamic> toJson}) {
    // TODO: implement addEvent
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteClub({required String clubID}) {
    // TODO: implement deleteClub
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteEvent({required String eventID}) {
    // TODO: implement deleteEvent
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
  Future<bool> editEvent({required String eventID}) {
    // TODO: implement editEvent
    throw UnimplementedError();
  }

  @override
  Future<bool> updateMyData() {
    // TODO: implement editUserData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure,List<EventEntity>>> getEvents() async {
    try
    {
      return Right(await eventsRemoteDataSource.getEvents());
    }
    on FirebaseException catch(exception)
    {
    return Left(ServerFailure(message: exception.code));
    }
  }

  @override
  Future<Either<Failure,List<NotificationEntity>>> getNotifications() async {
    try
    {
      return Right(await layoutRemoteDataSource.getNotifications());
    }
    on FirebaseException catch(exception){
      return Left(ServerFailure(message: exception.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMyData() async {
    try
    {
      return Right((await layoutRemoteDataSource.getMyData()));
    }
    on FirebaseException catch(e){
      return Left(ServerFailure(message: e.code));
    }
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> requestMembershipForASpecificClub({required String clubID}) {
    // TODO: implement requestMembershipForASpecificClub
    throw UnimplementedError();
  }

  @override
  Future<bool> sendANotification({required String receiverID}) {
    // TODO: implement sendANotification
    throw UnimplementedError();
  }

  @override
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID}) {
    // TODO: implement viewClubMembersInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ClubEntity>>> getClubs() async {
    try
    {
      List<ClubEntity> clubs = await clubsRemoteDataSource.getAllClubs();
      return right(clubs);
    }
    on FirebaseException catch(e){
      return left(ServerFailure(message: e.code));
    }
  }

}