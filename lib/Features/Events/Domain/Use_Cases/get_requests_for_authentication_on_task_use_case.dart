import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Data/Models/request_authentication_on_task_model.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class GedRequestForAuthenticateOnATaskUseCase{
  final EventsContractRepository eventsContractRepository;

  GedRequestForAuthenticateOnATaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure,List<RequestAuthenticationOnATaskModel>>> execute({required String taskID}) async {
    return await eventsContractRepository.gedRequestForAuthenticateOnATask(taskID: taskID);
  }

}