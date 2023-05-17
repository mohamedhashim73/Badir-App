import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Events/Data/Models/task_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class UpdateTaskUseCase{
  final EventsContractRepository eventsContractRepository;

  UpdateTaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure, Unit>> execute({required String taskID,required TaskModel taskModel}) async {
    return await eventsContractRepository.updateTask(taskID: taskID, taskModel: taskModel);
  }

}