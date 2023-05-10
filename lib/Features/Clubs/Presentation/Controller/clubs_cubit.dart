import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Clubs/Data/Models/club_model.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_all_clubs_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/upload_image_to_storage_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Core/Constants/constants.dart';
import '../../Domain/Entities/request_membership_entity.dart';
import '../../Domain/Use_Cases/accept_or_reject_membership_request_use_case.dart';
import '../../Domain/Use_Cases/get_all_membership_requests_use_case.dart';
import '../../Domain/Use_Cases/request_membership_use_case.dart';
import '../../Domain/Use_Cases/update_club_use_case.dart';
import 'clubs_states.dart';
import 'dart:io';

class ClubsCubit extends Cubit<ClubsStates> {
  ClubsCubit() : super(ClubsInitialState());

  static ClubsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<ClubEntity> clubs = [];
  Future<void> getClubsData() async {
    emit(GetClubsLoadingState());
    final result = await sl<GetAllClubsUseCase>().execute();
    result.fold(
            (serverFailure){
              clubs.clear();
              emit(FailedToGetClubsDataState(message: serverFailure.errorMessage));
            },
            (clubsData){
              clubs = clubsData;
              debugPrint("Clubs Number is : ${clubsData.length}");
              emit(GetClubsDataSuccessState());
            }
    );
  }

  // TODO: USED during request a membership
  String? selectedCommittee;
  void chooseCommittee({required String chosen}){
    selectedCommittee = chosen;
    emit(CommitteeChosenSuccessState());
  }

  // TODO: Ask for membership
  void askForMembership({required String clubID,required String infoAboutAsker,required String userName}) async {
    emit(SendRequestForMembershipLoadingState());
    bool requestSent = await sl<RequestAMembershipUseCase>().execute(
        clubID: clubID,
        userAskForMembershipID: Constants.userID!,
        infoAboutAsker: infoAboutAsker,
        committeeName: selectedCommittee!,
        requestUserName: userName
    );
    requestSent ? emit(SendRequestForMembershipSuccessState()) : emit(FailedToSendRequestForMembershipState());
  }

  bool searchEnabled = false;
  void changeSearchAboutClubStatus(){
    searchEnabled = !searchEnabled;
    emit(ChangeSearchAboutClubStatus());
  }

  List<ClubEntity> filteredClubsData = [];
  void searchAboutClub({required String input}){
    if( clubs.isNotEmpty )
      {
        filteredClubsData = clubs.where((element) => element.name!.toLowerCase().contains(input.toLowerCase())).toList();
        emit(GetFilteredClubsSuccessStatus());
      }
  }

  ClubEntity? dataAboutClubYouLead;
  void getInfoForClubThatILead({required String clubID}){
    dataAboutClubYouLead = clubs.firstWhere((element) => element.id == int.parse(clubID.trim()));
    if( dataAboutClubYouLead != null ) emit(GetInfoForClubThatILeadSuccess());
  }

  File? clubImage;
  void getClubImage() async {
    XFile? pickedFile = await Constants.getImageFromGallery();
    if( pickedFile != null )
      {
        clubImage = File(pickedFile!.path);
        emit(ChooseClubImageSuccess());
      }
    else
      {
        emit(ChooseClubImageFailure());
      }
  }

  Future<String?> uploadClubImageToStorage() async {
    String? url;
    final result = await sl<UploadClubImageToStorageUseCase>().execute(imageFile: clubImage!);
    await Future.value(
        result.fold(
                (noNetworkFailure){
                  emit(FailedToClubImage());
                },
                (imageUrl){
                  url = imageUrl;
                  emit(ClubImageUploadedSuccess());
            }
        ));
    return url;
  }

  void updateClubData({required String clubID,required File image,required String name,required int memberNum,required String aboutClub,required String phone,required String twitter}) async {
    emit(UpdateClubLoadingState());
    ContactMeansForClubModel contactMeansModel = ContactMeansForClubModel(phone: phone, twitter: twitter);
    String? imageURL = await uploadClubImageToStorage();
    // Update data on firestore
    final clubUpdateResult = await sl<UpdateClubUseCase>().execute(clubID: clubID, image: imageURL ?? '', name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactMeansModel);
    await Future.value(
        clubUpdateResult.fold(
                (serverFailure){
                   emit(FailedToUpdateClubState(message: serverFailure.errorMessage));
                },
                (unit) async {
                   await getClubsData();
                   emit(ClubUpdatedSuccessState());
                }
        ));
  }

  void updateClubWithoutImage({required String clubID,required String imgUrl,required String name,required int memberNum,required String aboutClub,required String phone,required String twitter}) async {
    ContactMeansForClubModel contactMeansModel = ContactMeansForClubModel(phone: phone, twitter: twitter);
    final clubUpdateResult = await sl<UpdateClubUseCase>().execute(clubID: clubID, image: imgUrl, name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactMeansModel);
    await Future.value(
        clubUpdateResult.fold(
                (serverFailure){
              emit(FailedToUpdateClubState(message: serverFailure.errorMessage));
            },
                (unit) async {
              await getClubsData();
              emit(ClubUpdatedSuccessState());
            }
        ));
  }

  void acceptOrRejectMembershipRequest({required LayoutCubit layoutCubit,required String requestSenderID,required String clubID,required bool respondStatus,required String clubName}) async {
    final result = await sl<AcceptOrRejectMembershipRequestUseCase>().execute(clubID: clubID,requestSenderID: requestSenderID,respondStatus: respondStatus);
    result.fold(
            (serverFailure){
              emit(FailedToAcceptOrRejectMembershipRequestState(message: serverFailure.errorMessage));
            },
            (unit) async {
              await layoutCubit.sendNotification(senderID: layoutCubit.userData!.id!, receiverID: requestSenderID, clubID: clubID, notifyContent: respondStatus ? "لقد تم قبول طلب العضوية في $clubName" : "لقد تم رفض طلب العضوية في $clubName", notifyType: respondStatus ? NotificationType.acceptYourMembershipRequest : NotificationType.rejectYourMembershipRequest);
              emit(AcceptOrRejectMembershipRequestSuccessState());
            }
    );
  }

  List<RequestMembershipEntity> membershipRequests = [];
  void getMembershipRequests({required String clubID}) async {
    emit(GetMembershipRequestLoadingState());
    final result = await sl<GetMembershipRequestsUseCase>().execute(clubID: clubID);
    result.fold(
            (serverFailure){
              emit(FailedToGetMembershipRequestsState(message: serverFailure.errorMessage));
            },
            (requests) async {
              membershipRequests = requests;
              emit(GetMembershipRequestSuccessState());
            }
    );
  }

}