import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Domain/Contract_Repositories/events_contract_repository.dart';
import '../Data_Sources/local_events_data_source.dart';
import '../Data_Sources/remote_events_data_source.dart';

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
  Future<Either<Failure,Unit>> deleteEvent({required String eventID}) async {
    try
    {
      await remoteEventsDataSource.deleteEvent(eventID: eventID);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<bool> editEvent({required String eventID}) {
    // TODO: implement editEvent
    throw UnimplementedError();
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

}