import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';

class CreateMeetingUseCase{
  final ClubsContractRepository clubsContractRepository;

  CreateMeetingUseCase({required this.clubsContractRepository});

  Future<Either<Failure,Unit>> execute({required String idForClubILead,required String name,required String description,required String date,required String time,required String location,required String link}) async {
    return await clubsContractRepository.createMeeting(idForClubILead: idForClubILead, name: name, description: description, date: date, time: time, location: location, link: link);
  }

}