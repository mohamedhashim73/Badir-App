import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/notification_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../Core/Errors/failure.dart';
import '../Entities/user_entity.dart';

// TODO: Contract Repository
abstract class LayoutBaseRepository{

  // TODO: USER
  Future<Either<Failure, UserEntity>> getMyData();
  Future<bool> updateMyData();
  Future<bool> logOut();
  Future<Either<Failure,List<ClubEntity>>> getClubs();


  // TODO: Notifications
  Future<Either<Failure,List<NotificationEntity>>> getNotifications();
  Future<bool> sendANotification({required String receiverID});

  // TODO: Events -- PUBLIC USER
  Future<Either<Failure,List<EventEntity>>> getEvents();

  // TODO: ( Leader )
  // TODO: Events -- LEADER ROLE
  Future<bool> addEvent({required Map<String,dynamic> toJson});
  Future<bool> editEvent({required String eventID});
  Future<bool> deleteEvent({required String eventID});

  // TODO: CLUBS -- LEADER ROLE
  Future<bool> addClub({required Map<String,dynamic> toJson});
  Future<bool> editClub({required String clubID});
  Future<bool> deleteClub({required String clubID});

  // TODO: ACCEPT OR REFUSE MEMBERSHIP REQUEST -- LEADER ROLE
  Future<bool> acceptOrRefuseMembershipRequest({required String requestSenderID});
  Future<bool> deleteMemberFromClub({required String memberID});
  Future<List<UserEntity>> viewClubMembersInfo({required String clubID});

  // TODO: Invitation to be a member on Specific Club ( Public Member, Leader on this club will be accept or refuse )
  Future<void> requestMembershipForASpecificClub({required String clubID});

}