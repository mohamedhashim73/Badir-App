abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates{}

class CollegeChosenSuccessState extends LayoutStates{}
class GenderChosenSuccessState extends LayoutStates{}

class UpdateMyDataSuccessState extends LayoutStates{}
class UpdateMyDataLoadingState extends LayoutStates{}
class FailedToUpdateMyDataState extends LayoutStates{}

class SendNotificationSuccessState extends LayoutStates{}
class FailedSendNotificationState extends LayoutStates{
  final String message;
  FailedSendNotificationState({required this.message});
}

class GetMyDataSuccessState extends LayoutStates{}
class FailedToGetUserDataState extends LayoutStates{
  final String message;
  FailedToGetUserDataState({required this.message});
}

class LogOutSuccessState extends LayoutStates{}
class FailedToLogOut extends LayoutStates{
  final String message;
  FailedToLogOut({required this.message});
}

class ErrorDuringOpenPdfState extends LayoutStates{
  final String message;
  ErrorDuringOpenPdfState({required this.message});
}

class ChangeBottomNavIndexState extends LayoutStates{}
class PdfSelectedSuccessState extends LayoutStates{}
class PdfSelectedWithFailureState extends LayoutStates{}

// Notifications
class FailedToGetNotificationsState extends LayoutStates{
  final String message;
  FailedToGetNotificationsState({required this.message});
}
class GetNotificationsSuccessState extends LayoutStates{}
class GetNotificationsLoadingState extends LayoutStates{}

class UploadReportToAdminWithFailureState extends LayoutStates{
  final String message;
  UploadReportToAdminWithFailureState({required this.message});
}
class UploadReportToAdminLoadingState extends LayoutStates{}
class UploadReportToAdminSuccessState extends LayoutStates{}

class FailedToGetAllUsersOnAppState extends LayoutStates{
  final String message;
  FailedToGetAllUsersOnAppState({required this.message});
}
class GetAllUsersOnAppSuccessState extends LayoutStates{}
