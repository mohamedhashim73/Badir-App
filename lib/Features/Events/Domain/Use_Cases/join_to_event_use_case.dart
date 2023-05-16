import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class JoinToEventUseCase{
  final EventsContractRepository eventsContractRepository;

  JoinToEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String eventID,required String memberID}) async {
    return eventsContractRepository.joinToEvent(eventID: eventID, memberID: memberID);
  }

}