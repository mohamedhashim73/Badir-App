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

class UpdateTaskSuccessState extends EventsStates{}
class UpdateTaskLoadingState extends EventsStates{}
class FailedToUpdateTaskState extends EventsStates{
  final String message;
  FailedToUpdateTaskState({required this.message});
}

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
