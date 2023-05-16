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

class GetMemberOnAnEventLoadingState extends EventsStates{}
class GetMembersOnAnEventSuccessState extends EventsStates{}
class FailedToGetMembersOnAnEventDataState extends EventsStates{
  final String message;
  FailedToGetMembersOnAnEventDataState({required this.message});
}


class CreateEventSuccessState extends EventsStates{}
class CreateEventLoadingState extends EventsStates{}
class FailedToCreateEventState extends EventsStates{
  final String message;
  FailedToCreateEventState({required this.message});
}
class EventsClassifiedSuccessState extends EventsStates{}
class EventsClassifiedLoadingState extends EventsStates{}

class DeleteEventSuccessState extends EventsStates{}
class DeleteEventLoadingState extends EventsStates{}
class FailedToDeleteEventState extends EventsStates{
  final String message;
  FailedToDeleteEventState({required this.message});
}

class JoinToEventLoadingState extends EventsStates{}
class JoinToEventSuccessState extends EventsStates{}
class FailedToJoinToEventState extends EventsStates{
  final String message;
  FailedToJoinToEventState({required this.message});
}
