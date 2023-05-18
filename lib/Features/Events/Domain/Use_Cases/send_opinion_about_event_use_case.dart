import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Data/Models/opinion_about_event_model.dart';
import '../Contract_Repositories/events_contract_repository.dart';

class SendOpinionAboutEventUseCase {
  final EventsContractRepository eventsContractRepository;

  SendOpinionAboutEventUseCase({required this.eventsContractRepository});

  Future<Either<Failure,Unit>> execute({required String eventID,required OpinionAboutEventModel opinionModel,required String senderID}) async {
    return await eventsContractRepository.sendOpinionAboutEvent(eventID: eventID, opinionModel: opinionModel, senderID: senderID);
  }

}