import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Events/Data/Models/task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Clubs/Domain/Entities/member_entity.dart';
import '../../../Layout/Presentation/Controller/layout_cubit.dart';
import '../../Domain/Contract_Repositories/events_contract_repository.dart';
import '../../Domain/Entities/task_entity.dart';
import '../Data_Sources/local_events_data_source.dart';
import '../Data_Sources/remote_events_data_source.dart';
import '../Models/event_model.dart';
import '../Models/opinion_about_event_model.dart';
import '../Models/request_authentication_on_task_model.dart';

class EventsImplyRepository implements EventsContractRepository{
  final RemoteEventsDataSource remoteEventsDataSource;
  final LocalEventsDataSource localEventsDataSource;

  EventsImplyRepository({required this.remoteEventsDataSource,required this.localEventsDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getAllEvents() async {
    try
    {
      final events = await remoteEventsDataSource.getAllEvents();
      return Right(events);
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> addEvent({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    try
    {
      await remoteEventsDataSource.createEvent(forPublic: forPublic, name: name, description: description, imageUrl: imageUrl, startDate: startDate, endDate: endDate, time: time, location: location, link: link, clubID: clubID, clubName: clubName);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> deleteEvent({required String eventID,required String clubID}) async {
    try
    {
      await remoteEventsDataSource.deleteEvent(eventID: eventID,clubID: clubID);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> updateEvent({required String eventID,required EventModel eventModel}) async {
    try
    {
      return Right(await remoteEventsDataSource.updateEvent(eventID: eventID,eventModel: eventModel));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  // TODO: Leader ....
  @override
  Future<Either<Failure,Unit>> createTask({required String taskName,required String ownerID,required String clubID,required String description,String? eventID,String? eventName,required bool forPublicOrSpecificToAnEvent,required int hours,required int numOfPosition }) async {
    try
    {
      return Right(await remoteEventsDataSource.createTask(clubID:clubID,ownerID: ownerID,eventName:eventName,eventID:eventID,taskName: taskName,description: description, forPublicOrSpecificToAnEvent: forPublicOrSpecificToAnEvent, hours: hours, numOfPosition: numOfPosition));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinToEvent({required String eventID, required String memberID}) async {
    try
    {
      await remoteEventsDataSource.joinToEvent(eventID: eventID, memberID: memberID);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<MemberEntity>>> getMembersOnAnEvent({required String eventID}) async {
    try
    {
      return Right(await remoteEventsDataSource.getMembersForAnEvent(eventID: eventID));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<TaskEntity>>> getAllTasksOnApp() async {
    try
    {
      return Right(await remoteEventsDataSource.getAllTasksOnApp());
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> deleteTask({required String taskID}) async {
    try
    {
      return Right(await remoteEventsDataSource.deleteTask(taskID: taskID));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> updateTask({required String taskID,required TaskModel taskModel}) async {
    try
    {
      return Right(await remoteEventsDataSource.updateTask(taskID: taskID,taskModel: taskModel));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> requestToAuthenticateOnATask({required String taskID,required String senderID,required String senderFirebaseFCMToken,required String senderName}) async {
    try
    {
      return Right(await remoteEventsDataSource.requestToAuthenticateOnATask(taskID: taskID, senderID: senderID, senderFirebaseFCMToken: senderFirebaseFCMToken,senderName: senderName));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Set>> getIDForTasksIAskedToAuthenticate({List? idForClubIMemberIn,required String userID}) async {
    try
    {
      return Right(await remoteEventsDataSource.getIDForTasksIAskedToAuthenticate(userID: userID,idForClubsIMemberIn: idForClubIMemberIn));
    }
    on ServerException catch(e) {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<RequestAuthenticationOnATaskModel>>> gedRequestForAuthenticateOnATask({required String taskID}) async {
    try
    {
      return Right(await remoteEventsDataSource.gedRequestForAuthenticateOnATask(taskID: taskID));
    }
    on ServerException catch(e) {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> sendOpinionAboutEvent({required String eventID,required OpinionAboutEventModel opinionModel,required String senderID}) async {
    try
    {
      return Right(await remoteEventsDataSource.sendOpinionAboutEvent(eventID: eventID, opinionModel: opinionModel, senderID: senderID));
    }
    on ServerException catch(e) {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,List<OpinionAboutEventModel>>> getOpinionsAboutEvent({required String eventID}) async{
    try
    {
      return Right(await remoteEventsDataSource.getOpinionsAboutEvent(eventID: eventID));
    }
    on ServerException catch(e) {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> acceptOrRejectAuthenticateRequestOnATask({required String requestFirebaseFCMToken,required String myID,required LayoutCubit layoutCubit,required String requestSenderName,required TaskEntity taskEntity,required String requestSenderID,required bool respondStatus}) async {
    try
    {
      return Right(await remoteEventsDataSource.acceptOrRejectAuthenticateRequestOnATask(requestFirebaseFCMToken: requestFirebaseFCMToken,myID: myID, layoutCubit: layoutCubit, requestSenderName: requestSenderName, taskEntity: taskEntity, requestSenderID: requestSenderID,respondStatus: respondStatus));
    }
    on ServerException catch(e) {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

}