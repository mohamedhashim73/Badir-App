import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Data/Models/meeting_model.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class GetMeetingRelatedToClubIMemberInUseCase{
  final ClubsContractRepository clubsContractRepository;

  GetMeetingRelatedToClubIMemberInUseCase({required this.clubsContractRepository});

  Future<Either<Failure,List<MeetingModel>>> execute({required List idForClubsMemberIn}) async {
    return await clubsContractRepository.getMeetingRelatedToClubIMemberIn(idForClubsMemberIn: idForClubsMemberIn);
  }

}