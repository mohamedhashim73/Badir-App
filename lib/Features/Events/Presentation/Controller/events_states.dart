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

class CreateEventSuccessState extends EventsStates{}
class CreateEventLoadingState extends EventsStates{}
class FailedToCreateEventState extends EventsStates{
  final String message;
  FailedToCreateEventState({required this.message});
}
