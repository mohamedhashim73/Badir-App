import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class GetIDForTasksThatIAskedForAuthenticationBeforeUseCase{
  final EventsContractRepository eventsContractRepository;

  GetIDForTasksThatIAskedForAuthenticationBeforeUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Set>> execute({List? idForClubIMemberIn,required String userID}) async {
    return await eventsContractRepository.getIDForTasksIAskedToAuthenticate(userID: userID,idForClubIMemberIn: idForClubIMemberIn);
  }

}