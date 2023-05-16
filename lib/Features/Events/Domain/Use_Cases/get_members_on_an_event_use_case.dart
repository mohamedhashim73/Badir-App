import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Clubs/Domain/Entities/member_entity.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class GetMembersOnAnEventUseCase{
  final EventsContractRepository eventsContractRepository;

  GetMembersOnAnEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure,List<MemberEntity>>> execute({required String eventID}) async {
    return eventsContractRepository.getMembersOnAnEvent(eventID: eventID);
  }

}