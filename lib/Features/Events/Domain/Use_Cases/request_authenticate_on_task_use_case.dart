import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class RequestAuthenticationOnATaskUseCase{
  final EventsContractRepository eventsContractRepository;

  RequestAuthenticationOnATaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String taskID,required String senderFirebaseFCMToken,required String senderID,required String senderName}) async {
    return await eventsContractRepository.requestToAuthenticateOnATask(senderFirebaseFCMToken: senderFirebaseFCMToken,taskID: taskID, senderID: senderID, senderName: senderName);
  }

}