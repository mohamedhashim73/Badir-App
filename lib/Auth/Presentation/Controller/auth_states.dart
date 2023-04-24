abstract class AuthStates{}

class AuthInitialState extends AuthStates{}

class UpdatePasswordSuccessState extends AuthStates{}

class ChangePasswordVisiblity extends AuthStates{}

class ChooseCollegeSuccessState extends AuthStates{}
class ChooseGenderSuccessState extends AuthStates{}

class SaveUserDateOnFirestoreSuccessState extends AuthStates{}
class FailedToSaveUserDateOnFirestoreState extends AuthStates{}

class LoginSuccessState extends AuthStates{}
class LoginLoadingState extends AuthStates{}
class LoginStateFailed extends AuthStates{
  String message;
  LoginStateFailed({required this.message});
}

class RegisterSuccessState extends AuthStates{}
class RegisterLoadingState extends AuthStates{}
class RegisterFailedState extends AuthStates{
  String message;
  RegisterFailedState({required this.message});
}

class SendPasswordResetEmailSuccessState extends AuthStates{}
class SendPasswordResetEmailFailureState extends AuthStates{}
class SendPasswordResetEmailLoadingState extends AuthStates{}
