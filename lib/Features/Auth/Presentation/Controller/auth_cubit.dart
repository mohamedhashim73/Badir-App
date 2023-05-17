import 'package:bader_user_app/Features/Auth/Data/Repositories/auth_remote_repository.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/login_use_case.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/register_use_case.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Network/sharedPref.dart';
import '../../Domain/UseCases/save_userData_use_case.dart';
import 'auth_states.dart';

// TODO: Deal with UseCases
class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitialState());

  static AuthCubit getInstance(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  String? selectedCollege;
  void chooseCollege({required String college}){
    selectedCollege = college;
    emit(ChooseCollegeSuccessState());
  }

  String? selectedGender;
  void chooseGender({required String gender}){
    selectedGender = gender;
    emit(ChooseGenderSuccessState());
  }

  void register({required String name,required String email,required int phone,required String password,required String gender,required String college}) async {
    emit(RegisterLoadingState());
    // Todo: ServiceLocator contain an instance from AuthBaseRepository
    final result = await RegisterUseCase(authBaseRepository: sl<AuthRemoteImplyRepository>()).execute(email: email, password: password);
    // TODO: left => result that on the left side ( Instance from Failure ) , right => Instance from UserCredential
    result.fold(
            (serverFailure)
            {
              emit(RegisterFailedState(message: serverFailure.errorMessage));
            },
            (right) async
            {
              // Todo: Send User Data to Firestore
              UserModel userModel = UserModel(name, right.user!.uid,null, email,"User", password, gender, college, phone,null,null,false,null,null,null,null);
              await SendUserDataToFirestoreUseCase(authBaseRepository: sl<AuthRemoteImplyRepository>()).execute(user: userModel, userID: right.user!.uid);
              emit(RegisterSuccessState());
            }
    );
  }

  void login({required String email,required String password}) async {
    emit(LoginLoadingState());
    final result = await LoginUseCase(authBaseRepository: sl<AuthRemoteImplyRepository>()).execute(email: email, password: password);
    debugPrint("Result is : $result");
    // TODO: left => result that on the left side ( Instance from Failure ) , right => Instance from UserCredential
    result.fold(
            (serverFailure) => emit(LoginStateFailed(message: serverFailure.errorMessage)),
            (right)
            async
            {
              await SharedPref.insertString(key: 'userID',value : right.user!.uid);
              Constants.userID = SharedPref.getString(key: 'userID');
              emit(LoginSuccessState());
            }
    );
  }

  bool passwordShown = false;
  void changePasswordVisiblity(){
    passwordShown = !passwordShown;
    emit(ChangePasswordVisiblity());
  }

}