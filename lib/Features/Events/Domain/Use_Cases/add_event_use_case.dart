import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class CreateEventUseCase{
  final EventsContractRepository eventsContractRepository;

  CreateEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure, Unit>> execute({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    return await eventsContractRepository.addEvent(forPublic: forPublic, name: name, description: description, imageUrl: imageUrl, startDate: startDate, endDate: endDate, time: time, location: location, link: link, clubID: clubID, clubName: clubName);
  }

}