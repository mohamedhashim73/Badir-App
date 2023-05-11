import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Errors/failure.dart';
import '../Entities/event_entity.dart';

abstract class EventsContractRepository{
  Future<Either<Failure,Unit>> addEvent({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName});
  Future<bool> editEvent({required String eventID});
  Future<Either<Failure,Unit>> deleteEvent({required String eventID});
  Future<Either<Failure,List<EventEntity>>> getAllEvents();
}