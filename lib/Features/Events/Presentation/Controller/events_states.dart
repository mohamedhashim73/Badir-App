import 'package:bader_user_app/Features/Events/Data/Models/request_authentication_on_task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';

import '../../Data/Models/opinion_about_event_model.dart';

abstract class EventsStates{}

class EventsInitialState extends EventsStates{}
class GetEventsCreatedByMeSuccessState extends EventsStates{}
class EventForPublicOrNotSelectedSuccessState extends EventsStates{}

class GetEventsForYourOwnClubSuccessState extends EventsStates{}
class ChooseEventImageSuccess extends EventsStates{}
class ChooseEventImageFailure extends EventsStates{}
class GetEventImageFromGallerySuccessState extends EventsStates{}
class FailedToGetEventImageFromGalleryState extends EventsStates{}

class GetEventsLoadingState extends EventsStates{}
class GetEventsDataSuccessState extends EventsStates{}
class FailedToGetEventsDataState extends EventsStates{
  final String message;
  FailedToGetEventsDataState({required this.message});
}

class GetEventsForSpecificClubLoadingState extends EventsStates{}
class GetEventsForSpecificClubSuccessState extends EventsStates{
  final List<EventEntity> eventsOnSpecificClub;
  GetEventsForSpecificClubSuccessState({required this.eventsOnSpecificClub});
}

class GetMemberOnAnEventLoadingState extends EventsStates{}
class GetMembersOnAnEventSuccessState extends EventsStates{}
class FailedToGetMembersOnAnEventDataState extends EventsStates{
  final String message;
  FailedToGetMembersOnAnEventDataState({required this.message});
}

class UpdateEventLoadingState extends EventsStates{}
class UpdateEventSuccessState extends EventsStates{}
class FailedToUpdateEventState extends EventsStates{
  final String message;
  FailedToUpdateEventState({required this.message});
}


class CreateEventSuccessState extends EventsStates{}
class CreateEventLoadingState extends EventsStates{}
class FailedToCreateEventState extends EventsStates{
  final String message;
  FailedToCreateEventState({required this.message});
}
class EventsClassifiedSuccessState extends EventsStates{}
class EventsClassifiedLoadingState extends EventsStates{}

class GetNamesOfEventsToUseInOptionsForCreatingTaskState extends EventsStates{}
class ChooseEventNameForTaskCreatedState extends EventsStates{}

class DeleteEventSuccessState extends EventsStates{}
class DeleteEventLoadingState extends EventsStates{}
class FailedToDeleteEventState extends EventsStates{
  final String message;
  FailedToDeleteEventState({required this.message});
}

class DeleteTaskSuccessState extends EventsStates{}
class DeleteTaskLoadingState extends EventsStates{}
class FailedToDeleteTaskState extends EventsStates{
  final String message;
  FailedToDeleteTaskState({required this.message});
}

class GetRequestForAuthenticateOnATaskSuccessState extends EventsStates{
  final List<RequestAuthenticationOnATaskModel> requests;
  GetRequestForAuthenticateOnATaskSuccessState({required this.requests});
}

class GetRequestForAuthenticateOnATaskLoadingState extends EventsStates{}
class FailedToGetRequestForAuthenticateOnATaskState extends EventsStates{
  final String message;
  FailedToGetRequestForAuthenticateOnATaskState({required this.message});
}

class RequestAuthenticateOnATaskSuccessState extends EventsStates{}
class RequestAuthenticateOnATaskLoadingState extends EventsStates{}
class FailedToRequestAuthenticateOnATaskState extends EventsStates{
  final String message;
  FailedToRequestAuthenticateOnATaskState({required this.message});
}

class AcceptOrRejectAuthenticateRequestOnATaskLoadingState extends EventsStates{}
class AcceptOrRejectAuthenticateRequestOnATaskSuccessState extends EventsStates{}
class FailedToAcceptOrRejectAuthenticateRequestOnATaskState extends EventsStates{
  final String message;
  FailedToAcceptOrRejectAuthenticateRequestOnATaskState({required this.message});
}

class SendOpinionAboutEventLoadingState extends EventsStates{}
class SendOpinionAboutEventSuccessState extends EventsStates{}
class FailedToSendOpinionAboutEventState extends EventsStates{
  final String message;
  FailedToSendOpinionAboutEventState({required this.message});
}

class GetOpinionsAboutEventLoadingState extends EventsStates{}
class GetOpinionsAboutEventSuccessState extends EventsStates{
  final List<OpinionAboutEventModel> opinions;
  GetOpinionsAboutEventSuccessState({required this.opinions});
}
class FailedToGetOpinionsAboutEventState extends EventsStates{
  final String message;
  FailedToGetOpinionsAboutEventState({required this.message});
}

class GetIDForTasksIAskedToAuthenticateSuccessState extends EventsStates{}
class FailedToGetIDForTasksIAskedToAuthenticateState extends EventsStates{
  final String message;
  FailedToGetIDForTasksIAskedToAuthenticateState({required this.message});
}

class UpdateTaskSuccessState extends EventsStates{}
class UpdateTaskLoadingState extends EventsStates{}
class FailedToUpdateTaskState extends EventsStates{
  final String message;
  FailedToUpdateTaskState({required this.message});
}

class GetAvailableTasksLoadingState extends EventsStates{}
class GetAvailableTasksSuccessState extends EventsStates{}

class CreateTaskSuccessState extends EventsStates{}
class CreateTaskLoadingState extends EventsStates{}
class FailedCreateTaskState extends EventsStates{
  final String message;
  FailedCreateTaskState({required this.message});
}

class JoinToEventLoadingState extends EventsStates{}
class JoinToEventSuccessState extends EventsStates{}
class FailedToJoinToEventState extends EventsStates{
  final String message;
  FailedToJoinToEventState({required this.message});
}

class GetAllTasksOnAppLoadingState extends EventsStates{}
class GetAllTasksOnAppSuccessState extends EventsStates{}
class FailedToGetAllTasksOnAppState extends EventsStates{
  final String message;
  FailedToGetAllTasksOnAppState({required this.message});
}

class GetTasksThatCreatedByMeSuccessState extends EventsStates{}
class GetTasksThatCreatedByMeLoadingState extends EventsStates{}
class FailedToGetTasksThatCreatedByMeState extends EventsStates{
  final String message;
  FailedToGetTasksThatCreatedByMeState({required this.message});
}
