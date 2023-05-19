import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetIDForClubsIAskedForMembershipUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetIDForClubsIAskedForMembershipUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Set>> execute({List? idForClubsMemberID,required String userID}) async {
    return await clubsContractRepository.getIDForClubsIAskedForMembership(userID: userID,idForClubsMemberID: idForClubsMemberID);
  }

}