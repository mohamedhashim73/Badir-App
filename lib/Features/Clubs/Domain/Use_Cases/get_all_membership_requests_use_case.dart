import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/request_membership_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetMembershipRequestsUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetMembershipRequestsUseCase({required this.clubsContractRepository});

  Future<Either<Failure, List<RequestMembershipEntity>>> execute({required String clubID}) async {
    return await clubsContractRepository.getMembershipRequests(clubID: clubID);
  }

}