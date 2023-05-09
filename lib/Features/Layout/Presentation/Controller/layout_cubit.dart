import 'dart:io';

import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/upload_image_to_storage_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Domain/Entities/notification_entity.dart';
import '../../Domain/Use Cases/get_my_data_use_case.dart';
import '../../Domain/Use Cases/get_notifications_use_case.dart';
import '../../Domain/Use Cases/send_notification.dart';
import '../../Domain/Use Cases/update_my_data_use_case.dart';
import '../Screens/home_screen.dart';
import '../Screens/notification_screen.dart';
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
    final result = await sl<GetNotificationsUseCase>().execute();
    result.fold(
            (serverFailure){
              emit(FailedToGetNotificationsState(message: serverFailure.errorMessage));
            },
            (notificationsData){
              notifications = notificationsData;
              debugPrint("Notifications length is : ${notificationsData.length}");
              emit(GetNotificationsSuccessState());
            }
    );
  }


  // TODO: USER
  UserEntity? userData;
  Future<void> getMyData() async {
    var result = await sl<GetMyDataUseCase>().execute();
    result.fold(
            (serverFailure) => emit(FailedToGetUserDataState(message: serverFailure.errorMessage)),
            (userEntity)
            {
              userData = userEntity;
              emit(GetMyDataSuccessState());
            });
  }

  Future<String?> uploadImageToStorage({required File imgFile}) async {
    String? url;
    var result = await sl<UploadImageToStorageUseCase>().execute(imgFile: imgFile);
    result.fold(
            (serverFailure) => emit(FailedToGetUserDataState(message: serverFailure.errorMessage)),
            (imgUrl){ url = imgUrl; emit(GetMyDataSuccessState()); });
    return url;
  }

  void updateMyData({required String name,required String college,required String gender,required int phone}) async {
    emit(UpdateMyDataLoadingState());
    bool dataUpdatedSuccess = await sl<UpdateMyDataUseCase>().execute(name: name, college: college, gender: gender, phone: phone);
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

  Future<void> sendNotification({required String senderID,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    var result = await sl<SendNotificationUseCase>().execute(clubID: clubID,receiverID: receiverID,notifyType: notifyType,notifyContent: notifyContent,senderID: senderID);
    result.fold(
            (serverFailure) => emit(FailedSendNotificationState(message: serverFailure.errorMessage)),
            (unit)
            {
              emit(SendNotificationSuccessState());
            });
  }

}