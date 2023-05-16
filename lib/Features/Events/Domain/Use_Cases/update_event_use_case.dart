import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Data/Models/event_model.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class UpdateEventUseCase{
  final EventsContractRepository eventsContractRepository;

  UpdateEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String eventID,required EventModel eventModel}) async {
    return eventsContractRepository.updateEvent(eventID: eventID, eventModel: eventModel);
  }

}