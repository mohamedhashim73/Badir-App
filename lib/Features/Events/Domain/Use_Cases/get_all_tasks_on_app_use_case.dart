import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';
import '../Entities/task_entity.dart';

class GetAllTasksOnAppUseCase {
  final EventsContractRepository eventsContractRepository;

  GetAllTasksOnAppUseCase({required this.eventsContractRepository});

  Future<Either<Failure,List<TaskEntity>>> execute() async {
    return await eventsContractRepository.getAllTasksOnApp();
  }

}