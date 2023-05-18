import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class UpdateClubAvailabilityUseCase{
  final ClubsContractRepository clubsContractRepository;

  UpdateClubAvailabilityUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required String clubID,required bool isAvailable,required List availableOnlyForThisCollege}) async {
    return await clubsContractRepository.updateClubAvailability(clubID: clubID, isAvailable: isAvailable, availableOnlyForThisCollege: availableOnlyForThisCollege);
  }

}