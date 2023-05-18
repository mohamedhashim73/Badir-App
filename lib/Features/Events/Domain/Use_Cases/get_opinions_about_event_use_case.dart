import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Data/Models/opinion_about_event_model.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class GetOpinionsAboutEventUseCase{
  final EventsContractRepository eventsContractRepository;

  GetOpinionsAboutEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure,List<OpinionAboutEventModel>>> execute({required String eventID}) async{
    return await eventsContractRepository.getOpinionsAboutEvent(eventID: eventID);
  }

}