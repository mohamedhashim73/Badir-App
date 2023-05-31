import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class UpdateMeetingUseCase{
  final ClubsContractRepository clubsContractRepository;

  UpdateMeetingUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required MeetingEntity meetingEntity,required String idForClubILead,required String name,required String description,required String date,required String time,required String location,required String link}) async {
    return await clubsContractRepository.updateMeeting(meetingEntity:meetingEntity,idForClubILead: idForClubILead, name: name, description: description, date: date, time: time, location: location, link: link);
  }

}