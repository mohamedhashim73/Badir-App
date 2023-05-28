import 'dart:io';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/log_out_use_case.dart';
import 'package:bader_user_app/Features/Layout/Domain/Use%20Cases/upload_image_to_storage_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../Domain/Entities/notification_entity.dart';
import '../../Domain/Use Cases/get_all_users_on_app_use_case.dart';
import '../../Domain/Use Cases/get_my_data_use_case.dart';
import '../../Domain/Use Cases/get_notifications_use_case.dart';
import '../../Domain/Use Cases/send_notification.dart';
import '../../Domain/Use Cases/update_my_data_use_case.dart';
import '../../Domain/Use Cases/upload_report_to_admin_use_case.dart';
import '../Screens/home_screen.dart';
import '../Screens/notification_screen.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit getInstance(BuildContext context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  List<Widget> layoutScreens = [
    HomeScreen(),
    NotificationsScreen(),
    ProfileScreen()
  ];

  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    emit(ChangeBottomNavIndexState());
  }

  void openPdf({required String link}) async {
    bool launchSuccess = await launch(link);
    if( launchSuccess == false ) emit(ErrorDuringOpenPdfState(message: "حدث خطأ ما عند محاوله فتح اللينك، برجاء المحاوله لاحقا"));
  }

  File? pdfFile;
  void getPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false
    );
    if (result != null && result.files.isNotEmpty && result.files.first.extension == 'pdf')
    {
      // TODO: Convert PlatformFile to File to be able to upload it
      pdfFile = File(result.files.first.path!);
      emit(PdfSelectedSuccessState());
    }
    else
    {
      emit(PdfSelectedWithFailureState());
    }
  }

  Future<void> uploadReport({required LayoutCubit layoutCubit,required String senderID,required String clubName,required String clubID,required String reportType}) async{
    emit(UploadReportToAdminLoadingState());
    String? pdfUrl = await layoutCubit.uploadFileToStorage(file: pdfFile!);
    // TODO: Connect with Firestore
    if( pdfUrl != null )
      {
        final result = await sl<UploadReportToAdminUseCase>().execute(clubName:clubName,senderID:senderID,clubID: clubID,pdfLink: pdfUrl,reportType: reportType);
        result.fold(
            (serverFailure)
            {
              emit(UploadReportToAdminWithFailureState(message: serverFailure.errorMessage));
            },
            (unit){
              emit(UploadReportToAdminSuccessState());
            }
        );
      }
    else
      {
        emit(UploadReportToAdminWithFailureState(message: 'حدث خطأ اثناء رفع الملف برجاء المحاوله لاحقا'));
      }
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

  // TODO: USE it on Upload Report To Admin Screen
  String? reportType;
  void chooseReportType({required String chosen}){
    reportType = chosen;
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

  // TODO: Get All Users On App | Use it to get Members on Club that I lead .....
  List<UserEntity> allUsersDataOnApp = [];
  Future<void> getAllUsersOnApp () async {
    final result = await sl<GetAllUsersOnAppUseCase>().execute();
    result.fold(
        (serverFailure){
          emit(FailedToGetAllUsersOnAppState(message: serverFailure.errorMessage));
        },
        (users){
          allUsersDataOnApp = users;
          emit(GetAllUsersOnAppSuccessState());
        }
    );
  }

  Future<void> logout({required BuildContext context,required EventsCubit eventsCubit,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,}) async {
    var result = await sl<LogOutUseCase>().execute(layoutCubit: layoutCubit,clubsCubit: clubsCubit,eventsCubit: eventsCubit);
    result.fold(
        (serverFailure) => emit(FailedToLogOut(message: serverFailure.errorMessage)),
        (unit)
        {
          emit(LogOutSuccessState());
        });
  }

  // TODO: USER
  UserEntity? userData;
  Future<void> getMyData({ClubsCubit? clubsCubit}) async {
    // TODO: ClubsCubit? clubsCubit not required عشان هباصي قيمه فقط لو جالي notification فيه ان اصبحت قائد علي نادي to getDataAboutClubILead from this cubit
    var result = await sl<GetMyDataUseCase>().execute();
    result.fold(
            (serverFailure) => emit(FailedToGetUserDataState(message: serverFailure.errorMessage)),
            (user) async
            {
              userData = user;
              if( clubsCubit != null && user.idForClubLead != null )
                {
                  await clubsCubit.getCLubDataThatILead(clubID: user.idForClubLead!);
                }
              emit(GetMyDataSuccessState());
            });
  }

  Future<String?> uploadFileToStorage({required File file}) async {
    String? url;
    var result = await sl<UploadImageToStorageUseCase>().execute(imgFile: file);
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

  Future<void> sendNotification({required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    var result = await sl<SendNotificationUseCase>().execute(clubID: clubID,receiverID: receiverID,notifyType: notifyType,notifyContent: notifyContent);
    result.fold(
            (serverFailure) => emit(FailedSendNotificationState(message: serverFailure.errorMessage)),
            (unit)
            {
              emit(SendNotificationSuccessState());
            });
  }

}