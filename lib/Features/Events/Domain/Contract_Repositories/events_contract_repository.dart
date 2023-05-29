import 'package:bader_user_app/Features/Clubs/Domain/Entities/member_entity.dart';
import 'package:bader_user_app/Features/Events/Data/Models/task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/task_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Errors/failure.dart';
import '../../../Layout/Presentation/Controller/layout_cubit.dart';
import '../../Data/Models/event_model.dart';
import '../../Data/Models/opinion_about_event_model.dart';
import '../../Data/Models/request_authentication_on_task_model.dart';
import '../Entities/event_entity.dart';

abstract class EventsContractRepository{

  Future<Either<Failure,Unit>> addEvent({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName});
  Future<Either<Failure,Unit>> updateEvent({required String eventID,required EventModel eventModel});
  Future<Either<Failure,Unit>> deleteEvent({required String eventID,required String clubID});
  Future<Either<Failure,List<EventEntity>>> getAllEvents();
  Future<Either<Failure,List<TaskEntity>>> getAllTasksOnApp();
  Future<Either<Failure,Unit>> joinToEvent({required String eventID,required String memberID});
  Future<Either<Failure,List<MemberEntity>>> getMembersOnAnEvent({required String eventID});
  Future<Either<Failure,Unit>> createTask({required String taskName,required String ownerID,required String clubID,required String description,String? eventID,String? eventName,required bool forPublicOrSpecificToAnEvent,required int hours,required int numOfPosition });
  Future<Either<Failure,Unit>> deleteTask({required String taskID});
  Future<Either<Failure,Unit>> updateTask({required String taskID,required TaskModel taskModel});
  Future<Either<Failure,Unit>> requestToAuthenticateOnATask({required String taskID,required String senderFirebaseFCMToken,required String senderID,required String senderName});
  // TODO: هترجع id بتاع التاسكات اللي انا بعت طلب تسجيل فيها بالفعل
  Future<Either<Failure,Set>> getIDForTasksIAskedToAuthenticate({List? idForClubIMemberIn,required String userID});
  Future<Either<Failure,List<RequestAuthenticationOnATaskModel>>> gedRequestForAuthenticateOnATask({required String taskID});
  Future<Either<Failure,Unit>> acceptOrRejectAuthenticateRequestOnATask({required String requestFirebaseFCMToken,required String myID,required LayoutCubit layoutCubit,required String requestSenderName,required TaskEntity taskEntity,required String requestSenderID,required bool respondStatus});
  Future<Either<Failure,Unit>> sendOpinionAboutEvent({required String eventID,required OpinionAboutEventModel opinionModel,required String senderID});
  Future<Either<Failure,List<OpinionAboutEventModel>>> getOpinionsAboutEvent({required String eventID});
}