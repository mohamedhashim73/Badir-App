import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class GetAllEventsUseCase{
  final EventsContractRepository eventsContractRepository;

  GetAllEventsUseCase({required this.eventsContractRepository});

  Future<Either<Failure, List<EventEntity>>> execute() async {
    return await eventsContractRepository.getAllEvents();
  }

}