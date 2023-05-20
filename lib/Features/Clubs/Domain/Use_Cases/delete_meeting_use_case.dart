import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Data/Models/meeting_model.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class DeleteMeetingUseCase{
  final ClubsContractRepository clubsContractRepository;

  DeleteMeetingUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required String meetingID,required String clubID}) async {
    return await clubsContractRepository.deleteMeeting(clubID: clubID,meetingID: meetingID);
  }

}