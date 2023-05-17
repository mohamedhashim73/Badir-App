import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class DeleteTaskUseCase{
  final EventsContractRepository eventsContractRepository;

  DeleteTaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure, Unit>> execute({required String taskID}) async {
    return eventsContractRepository.deleteTask(taskID: taskID);
  }

}