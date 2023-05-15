import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class AcceptOrRejectMembershipRequestUseCase{
  final ClubsContractRepository clubsContractRepository;

  AcceptOrRejectMembershipRequestUseCase({required this.clubsContractRepository});

  Future<Either<Failure, Unit>> execute({required String committeeNameForRequestSender,required String requestSenderID,required String clubID,required bool respondStatus}) async {
    return await clubsContractRepository.acceptOrRejectMembershipRequest(committeeNameForRequestSender: committeeNameForRequestSender,requestSenderID: requestSenderID, clubID: clubID, respondStatus: respondStatus);
  }

}