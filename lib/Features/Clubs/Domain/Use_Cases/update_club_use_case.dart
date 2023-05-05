import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../Data/Models/club_model.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class UpdateClubUseCase{
  final ClubsContractRepository clubsContractRepository;

  UpdateClubUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required String clubID,required String image,required String name,required int memberNum,required String aboutClub,required ContactMeansForClubModel contactInfo}) async {
    return await clubsContractRepository.updateClubData(clubID: clubID, image: image, name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactInfo);
  }

}