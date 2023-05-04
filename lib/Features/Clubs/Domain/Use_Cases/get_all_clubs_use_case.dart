import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetAllClubsUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetAllClubsUseCase({required this.clubsContractRepository});

  Future<Either<Failure, List<ClubEntity>>> execute() async {
    return await clubsContractRepository.getClubs();
  }

}