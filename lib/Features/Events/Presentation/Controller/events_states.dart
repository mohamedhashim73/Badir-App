abstract class EventsStates{}

class EventsInitialState extends EventsStates{}

class GetEventsLoadingState extends EventsStates{}
class GetEventsDataSuccessState extends EventsStates{}
class FailedToGetEventsDataState extends EventsStates{
  final String message;
  FailedToGetEventsDataState({required this.message});
}
