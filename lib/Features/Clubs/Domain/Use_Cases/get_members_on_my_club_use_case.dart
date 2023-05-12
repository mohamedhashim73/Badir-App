import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/member_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetMembersDataOnMyClubUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetMembersDataOnMyClubUseCase({required this.clubsContractRepository});

  Future<Either<Failure, Set<String>>> execute({required String idForClubILead}) async {
    return await clubsContractRepository.getMembersOnMyClub(idForClubILead: idForClubILead);
  }

}