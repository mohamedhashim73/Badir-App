abstract class LayoutStates{}

class LayoutInitialState extends LayoutStates{}

class CollegeChosenSuccessState extends LayoutStates{}
class GenderChosenSuccessState extends LayoutStates{}

class UpdateMyDataSuccessState extends LayoutStates{}
class UpdateMyDataLoadingState extends LayoutStates{}
class FailedToUpdateMyDataState extends LayoutStates{}

class GetMyDataSuccessState extends LayoutStates{}
class FailedToGetUserDataState extends LayoutStates{
  final String message;
  FailedToGetUserDataState({required this.message});
}

class ChangeBottomNavIndexState extends LayoutStates{}

// Notifications
class FailedToGetNotificationsState extends LayoutStates{
  final String message;
  FailedToGetNotificationsState({required this.message});
}
class GetNotificationsSuccessState extends LayoutStates{}
class GetNotificationsLoadingState extends LayoutStates{}