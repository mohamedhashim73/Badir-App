import 'package:dartz/dartz.dart';
import '../../../../Core/Errors/failure.dart';
import '../Entities/event_entity.dart';

abstract class EventsContractRepository{
  Future<bool> addEvent({required Map<String,dynamic> toJson});
  Future<bool> editEvent({required String eventID});
  Future<bool> deleteEvent({required String eventID});
  Future<Either<Failure,List<EventEntity>>> getEvents();
}