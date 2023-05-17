import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class CreateTaskUseCase{
  final EventsContractRepository eventsContractRepository;

  CreateTaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String taskName,required String ownerID,required String clubID,required String description,String? eventID,String? eventName,required bool forPublicOrSpecificToAnEvent,required int hours,required int numOfPosition }) async {
    return await eventsContractRepository.createTask(clubID:clubID,ownerID:ownerID,eventName:eventName,eventID:eventID,taskName: taskName,description: description, forPublicOrSpecificToAnEvent: forPublicOrSpecificToAnEvent, hours: hours, numOfPosition: numOfPosition);
  }

}