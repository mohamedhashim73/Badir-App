import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Domain/Contract_Repositories/events_contract_repository.dart';
import '../Data_Sources/local_events_data_source.dart';
import '../Data_Sources/remote_events_data_source.dart';

class EventsImplyRepository implements EventsContractRepository{
  final RemoteEventsDataSource remoteEventsDataSource;
  final LocalEventsDataSource localEventsDataSource;

  EventsImplyRepository({required this.remoteEventsDataSource,required this.localEventsDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try
    {
      final events = await remoteEventsDataSource.getEvents();
      return Right(events);
    }
    on ServerException catch(exception)
    {
      return Left(ServerFailure(errorMessage: exception.exceptionMessage));
    }
  }

  @override
  Future<bool> addEvent({required Map<String, dynamic> toJson}) {
    // TODO: implement addEvent
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteEvent({required String eventID}) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<bool> editEvent({required String eventID}) {
    // TODO: implement editEvent
    throw UnimplementedError();
  }

}