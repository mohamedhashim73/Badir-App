import 'package:bader_user_app/Features/Auth/Data/Repositories/auth_remote_repository.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/login_use_case.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/register_use_case.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Auth/Domain/UseCases/update_firebase_messaging_token_use_case.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Network/sharedPref.dart';
import '../../Domain/UseCases/save_userData_use_case.dart';
import 'auth_states.dart';
import 'dart:io';

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
    final result = await sl<RegisterUseCase>().execute(email: email, password: password);
    // TODO: left => result that on the left side ( Instance from Failure ) , right => Instance from UserCredential
    result.fold(
            (serverFailure)
            {
              emit(RegisterFailedState(message: serverFailure.errorMessage));
            },
            (right) async
            {
              // TODO: I will use firebaseMessagingToken in send notification to this User
              String? firebaseMessagingToken;
              Constants.isPhysicalDevice().then((value) async {
                if( value )
                {
                  firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
                }
              });
              // Todo: Send User Data to Firestore
              UserModel userModel = UserModel(name, right.user!.uid,firebaseMessagingToken,null, email,"User", password, gender, college, phone,null,null,false,null,null,null,null);
              await SendUserDataToFirestoreUseCase(authBaseRepository: sl<AuthImplyRepository>()).execute(user: userModel, userID: right.user!.uid);
              emit(RegisterSuccessState());
            }
    );
  }

  void login({required String email,required String password,required LayoutCubit layoutCubit}) async {
    emit(LoginLoadingState());
    final result = await sl<LoginUseCase>().execute(email: email, password: password);
    debugPrint("Result is : $result");
    // TODO: left => result that on the left side ( Instance from Failure ) , right => Instance from UserCredential
    result.fold(
            (serverFailure) => emit(LoginStateFailed(message: serverFailure.errorMessage)),
            (userCredential)
            async
            {
              bool appOnRealDevice = await Constants.isPhysicalDevice();
              debugPrint("App run on real Device is : $appOnRealDevice , operating id is : ${Platform.operatingSystemVersion}");
              if( appOnRealDevice == true )
              {
                await FirebaseMessaging.instance.subscribeToTopic("all");     // TODO: عشان بعدين لو حبت ابعت حاجه لكل المتسخدمين هبعت من خلال Topic ده
                await sl<UpdateMyFirebaseMessagingTokenUseCase>().execute(userID: userCredential.user!.uid);
              }
              await SharedPref.insertString(key: 'userID',value : userCredential.user!.uid);
              Constants.userID = SharedPref.getString(key: 'userID');
              await layoutCubit.getMyData();
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