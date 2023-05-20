import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../Layout/Domain/Entities/user_entity.dart';
import '../../Data/Models/meeting_model.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetMemberDataUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetMemberDataUseCase({required this.clubsContractRepository});

  Future<Either<Failure,UserEntity>> execute({required String memberID}) async {
    return await clubsContractRepository.getMemberData(memberID: memberID);
  }

}