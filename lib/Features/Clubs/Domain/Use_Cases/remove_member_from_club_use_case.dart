import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class RemoveMemberFromClubILeadUseCase{
  final ClubsContractRepository clubsContractRepository;

  RemoveMemberFromClubILeadUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required String memberID,required String clubID}) async {
    return clubsContractRepository.removeMemberFromClubILead(memberID: memberID, clubID: clubID);
  }

}