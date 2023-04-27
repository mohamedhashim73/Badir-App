import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Clubs_UseCases/request_membership_use_case.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Layout_UseCases/get_notifications_use_case.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Layout_UseCases/update_my_data_use_case.dart';
import 'package:bader_user_app/Layout/Presentation/Screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../Domain/Entities/notification_entity.dart';
import '../../../Domain/UseCases/Layout_UseCases/get_my_data_use_case.dart';
import '../../Screens/home_screen.dart';
import '../../Screens/notification_screen.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit getInstance(BuildContext context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  List<Widget> layoutScreens = const [
    HomeScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    emit(ChangeBottomNavIndexState());
  }

  String? selectedCollege;
  void chooseCollege({required String college}){
    selectedCollege = college;
    emit(CollegeChosenSuccessState());
  }

  String? selectedGender;
  void chooseGender({required String gender}){
    selectedGender = gender;
    emit(GenderChosenSuccessState());
  }

  // TODO: Get Notifications
  List<NotificationEntity> notifications = [];
  void getNotifications() async {
    emit(GetNotificationsLoadingState());
    final result = await GetNotificationsUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute();
    result.fold(
            (l){
              notifications.clear();
              emit(FailedToGetNotificationsState(l.message));
            },
            (r){
              notifications = r;
              debugPrint("Notifications length is : ${r.length}");
              emit(GetNotificationsSuccessState());
            }
    );
  }


  // TODO: USER
  UserEntity? userData;
  Future<void> getMyData() async {
    var result = await GetMyDataUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute();
    result.fold(
            (serverFailure) => emit(FailedToGetUserDataState(message: serverFailure.message)),
            (userEntity)
            {
              userData = userEntity;
              emit(GetMyDataSuccessState());
            });
  }

  void updateMyData({required String name,required String college,required String gender,required int phone}) async {
    emit(UpdateMyDataLoadingState());
    bool dataUpdatedSuccess = await UpdateMyDataUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute(name: name, college: college, gender: gender, phone: phone);
    if( dataUpdatedSuccess )
      {
        await getMyData();
        emit(UpdateMyDataSuccessState());
      }
    else
      {
        emit(FailedToUpdateMyDataState());
      }
  }

}