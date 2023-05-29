import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../Layout/Presentation/Controller/layout_cubit.dart';
import '../Contract_Repositories/events_contract_repository.dart';
import '../Entities/task_entity.dart';

class AcceptOrRejectAuthenticateRequestOnATaskUseCase{
  final EventsContractRepository eventsContractRepository;

  AcceptOrRejectAuthenticateRequestOnATaskUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String requestFirebaseFCMToken,required String myID,required LayoutCubit layoutCubit,required String requestSenderName,required TaskEntity taskEntity,required String requestSenderID,required bool respondStatus}) async {
    return await eventsContractRepository.acceptOrRejectAuthenticateRequestOnATask(requestFirebaseFCMToken:requestFirebaseFCMToken,myID: myID, layoutCubit: layoutCubit, requestSenderName: requestSenderName, taskEntity: taskEntity, requestSenderID: requestSenderID, respondStatus: respondStatus);
  }

}