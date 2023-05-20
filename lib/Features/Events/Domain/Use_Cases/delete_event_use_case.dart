import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class DeleteEventUseCase{
  final EventsContractRepository eventsContractRepository;

  DeleteEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure, Unit>> execute({required String eventID,required String clubID}) async {
    return await eventsContractRepository.deleteEvent(eventID: eventID,clubID: clubID);
  }

}