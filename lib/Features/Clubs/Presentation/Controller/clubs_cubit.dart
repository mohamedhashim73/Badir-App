import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Clubs/Data/Models/club_model.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/delete_meeting_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_all_clubs_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_member_data_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_members_on_my_club_use_case.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/upload_image_to_storage_use_case.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Core/Constants/constants.dart';
import '../../Domain/Entities/request_membership_entity.dart';
import '../../Domain/Use_Cases/accept_or_reject_membership_request_use_case.dart';
import '../../Domain/Use_Cases/create_meeting_use_case.dart';
import '../../Domain/Use_Cases/get_all_membership_requests_use_case.dart';
import '../../Domain/Use_Cases/get_id_for_clubs_that_i_ask_for_membershi_waiting_result_use_case.dart';
import '../../Domain/Use_Cases/get_meetings_created_by_me_use_case.dart';
import '../../Domain/Use_Cases/get_meetings_for_club_member_in_use_case.dart';
import '../../Domain/Use_Cases/remove_member_from_club_use_case.dart';
import '../../Domain/Use_Cases/request_membership_use_case.dart';
import '../../Domain/Use_Cases/update_availability_for_club_use_case.dart';
import '../../Domain/Use_Cases/update_club_use_case.dart';
import 'clubs_states.dart';
import 'dart:io';

class ClubsCubit extends Cubit<ClubsStates> {
  ClubsCubit() : super(ClubsInitialState());

  static ClubsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<ClubEntity> clubs = [];
  Future<void> getAllClubs({UserEntity? userEntity}) async {
    emit(GetClubsLoadingState());
    final result = await sl<GetAllClubsUseCase>().execute();
    result.fold(
            (serverFailure) {
              emit(FailedToGetClubsDataState(message: serverFailure.errorMessage));
            },
            (clubsData) async {
              clubs = clubsData;
              if( userEntity != null && userEntity.idForClubLead == null ) await getIDForClubsIAskedForMembership(userID: userEntity.id ?? Constants.userID!, idForClubsMemberID: userEntity.idForClubsMemberIn);
              emit(GetClubsDataSuccessState());
            }
    );
  }

  // TODO: CREATE MEETING
  Future<void> createMeeting({required String idForClubILead,required String name,required String description,required String date,required String time,required String location,required String link}) async {
    emit(CreateMeetingLoadingState());
    final result = await sl<CreateMeetingUseCase>().execute(idForClubILead: idForClubILead, name: name, description: description, date: date, time: time, location: location, link: link);
    result.fold(
        (serverFailure){
          emit(CreateMeetingWithFailureState(message: serverFailure.errorMessage));
        },
        (unit) async {
          await getMeetingsCreatedByMe(clubID: idForClubILead);
          emit(CreateMeetingSuccessState());
        }
    );
  }

  Future<void> getDataAboutSpecificMember({required String memberID}) async {
    emit(GetMemberDataLoadingState());
    final result = await sl<GetMemberDataUseCase>().execute(memberID:memberID);
    result.fold(
        (serverFailure)
        {
          emit(GetMemberDataWithFailureState(message: serverFailure.errorMessage));
        },
        (user)
        {
          emit(GetMemberDataSuccessState(userEntity: user));
        }
    );
  }

  Future<void> getMeetingRelatedToClubIMemberIn({required List idForClubsMemberIn}) async {
    emit(GetMeetingRelatedToClubIMemberInLoadingState());
    final result = await sl<GetMeetingRelatedToClubIMemberInUseCase>().execute(idForClubsMemberIn: idForClubsMemberIn);
    result.fold(
        (serverFailure)
        {
          emit(GetMeetingRelatedToClubIMemberInWithFailureState(message: serverFailure.errorMessage));
        },
        (meetingsData)
        {
          emit(GetMeetingRelatedToClubIMemberInSuccessState(meetings: meetingsData));
        }
    );
  }

  // TODO: Get MEETINGS CREATED BY ME
  List<MeetingEntity> meetingsDataCreatedByMe = [];
    Future<void> getMeetingsCreatedByMe({required String clubID}) async {
    meetingsDataCreatedByMe.clear();
    emit(GetMeetingCreatedByLoadingState());
    final result = await sl<GetMeetingsCreatedByMeUseCase>().execute(clubID:clubID);
        result.fold(
        (serverFailure){
          emit(GetMeetingCreatedByWithFailureState(message: serverFailure.errorMessage));
        },
        (meetings)
        {
          meetingsDataCreatedByMe = meetings;
          debugPrint("Num of meetings is : ${meetings.length}");
          emit(GetMeetingCreatedBySuccessState());
        }
    );
  }

  // TODO: Get MEETINGS CREATED BY ME
  Future<void> deleteMeeting({required String clubID,required String meetingID}) async {
    emit(DeleteMeetingLoadingState());
    final result = await sl<DeleteMeetingUseCase>().execute(clubID:clubID,meetingID:meetingID);
    result.fold(
        (serverFailure){
          emit(DeleteMeetingWithFailureState(message: serverFailure.errorMessage));
        },
        (unit)
        async {
          await getMeetingsCreatedByMe(clubID: clubID);
          emit(DeleteMeetingSuccessState());
        }
    );
  }

  // TODO: CREATE MEETING
  Future<void> updateClubAvailability({required UserEntity userEntity,required String clubID,required bool isAvailable,required List availableOnlyForThisCollege}) async {
    emit(UpdateClubAvailabilityLoadingState());
    final result = await sl<UpdateClubAvailabilityUseCase>().execute(clubID: clubID, isAvailable: isAvailable, availableOnlyForThisCollege: availableOnlyForThisCollege);
    result.fold(
        (serverFailure)
        {
          emit(UpdateClubAvailabilityWithFailureState(message: serverFailure.errorMessage));
        },
        (unit) async
        {
          await getAllClubs(userEntity: userEntity);
          await getCLubDataThatILead(clubID: clubID);
          emit(UpdateClubAvailabilitySuccessState());
        }
    );
  }

  // TODO: Get Notifications
  List<UserEntity> membersDataOnMyClub = [];    // TODO: I lead
  Future<void> getMembersDataOnMyClub({required LayoutCubit layoutCubit,required String idForClubILead}) async {
    await layoutCubit.getAllUsersOnApp();
    membersDataOnMyClub.clear();    // TODO: To Get New Data Every time i call it
    List<UserEntity> usersOnApp = layoutCubit.allUsersDataOnApp;    // TODO: As it take value from getAllUsersOnApp() method
    emit(GetMembersOnMyClubDataLoadingState());
    final result = await sl<GetMembersDataOnMyClubUseCase>().execute(idForClubILead: idForClubILead);
    result.fold(
            (serverFailure){
              emit(GetMembersOnMyClubDataWithFailureState(message: serverFailure.errorMessage));
            },
            (membersID){
              debugPrint("All Users on App num is : ${usersOnApp.length}");
              // هنا هلوب علي المستخدمين بالكامل ولو لقيت id بتاعه في set اللي جايه من ال result هضيفه للداتا تبع الأعضاء
              for( var userEntity in usersOnApp )
                {
                  // TODO: Mean that this User already Member on Club I lead .....
                  if( membersID.contains(userEntity.id) )
                    {
                      membersDataOnMyClub.add(userEntity);
                    }
                }
              debugPrint("Members on My Club Number is : ${membersDataOnMyClub.length}");
              emit(GetMembersOnMyClubDataSuccessState());
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
  void askForMembership({required UserEntity userEntity,required String senderFirebaseFCMToken,required String clubID,required String infoAboutAsker,required String userName,required String committeeName}) async {
    emit(SendRequestForMembershipLoadingState());
    bool requestSent = await sl<RequestAMembershipUseCase>().execute(
        clubID: clubID,
        senderFirebaseFCMToken: senderFirebaseFCMToken,
        userAskForMembershipID: Constants.userID!,
        infoAboutAsker: infoAboutAsker,
        committeeName: committeeName,
        requestUserName: userName
    );
    if( requestSent )
      {
        await getAllClubs(userEntity: userEntity);
        emit(SendRequestForMembershipSuccessState());
      }
    else
      {
        emit(FailedToSendRequestForMembershipState());
      }
  }

  bool searchEnabled = false;
  void changeSearchAboutClubStatus({bool? value}){
    searchEnabled = value == null ? !searchEnabled : value;      // TODO: لان ف بعض الحالات هعوز اخليها false ف هبعت value ساعتها
    emit(ChangeSearchAboutClubStatus());
  }

  List<ClubEntity> filteredClubsData = [];
  void searchAboutClub({required String input}){
    if( clubs.isNotEmpty )
      {
        filteredClubsData = clubs.where((element) => element.name!.toLowerCase().contains(input.toLowerCase())).toList();
        emit(GetFilteredClubsSuccessState());
      }
  }

  // TODO: ده عشان الاسكرينه بتاع تحديد الكليات اللي مسموح لها بالانضمام للنادي
  List selectedColleges = [];
  void addOrRemoveOptionToSelectedColleges({required bool status,required String college}){
    status ? selectedColleges.add(college) : selectedColleges.remove(college);
    emit(AddOrRemoveOptionToSelectedCollegesState());
  }

  // TODO: ده عشان الاسكرينه بتاع تحديد الكليات اللي مسموح لها بالانضمام للنادي
  bool clubAvailabilityStatus = true;
  void changeClubAvailabilityStatus({required bool status}){
    clubAvailabilityStatus = status;
    emit(ChangeClubAvailabilityStatusState());
  }

  ClubEntity? dataAboutClubYouLead;
  Future<void> getCLubDataThatILead({required String clubID}) async {
    dataAboutClubYouLead = clubs.firstWhere((element) => element.id == int.parse(clubID.trim()));
    if( dataAboutClubYouLead != null )
      {
        emit(GetInfoForClubThatILeadSuccess());
      }
  }

  File? clubImage;
  void getClubImage() async {
    XFile? pickedFile = await Constants.getImageFromGallery();
    if( pickedFile != null )
      {
        clubImage = File(pickedFile.path);
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

  void updateClubData({required UserEntity userEntity,required String clubID,required File image,required String name,required int memberNum,required String aboutClub,required String email,required String twitter}) async {
    emit(UpdateClubLoadingState());
    ContactMeansForClubModel contactMeansModel = ContactMeansForClubModel(email: email, twitter: twitter);
    String? imageURL = await uploadClubImageToStorage();
    // Update data on firestore
    final clubUpdateResult = await sl<UpdateClubUseCase>().execute(clubID: clubID, image: imageURL ?? '', name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactMeansModel);
    await Future.value(
        clubUpdateResult.fold(
                (serverFailure){
                   emit(FailedToUpdateClubState(message: serverFailure.errorMessage));
                },
                (unit) async {
                   await getAllClubs(userEntity: userEntity);
                   emit(ClubUpdatedSuccessState());
                }
        ));
  }

  void updateClubWithoutImage({required UserEntity userEntity,required String clubID,required String imgUrl,required String name,required int memberNum,required String aboutClub,required String email,required String twitter}) async {
    ContactMeansForClubModel contactMeansModel = ContactMeansForClubModel(email: email, twitter: twitter);
    final clubUpdateResult = await sl<UpdateClubUseCase>().execute(clubID: clubID, image: imgUrl, name: name, memberNum: memberNum, aboutClub: aboutClub, contactInfo: contactMeansModel);
    await Future.value(
        clubUpdateResult.fold(
            (serverFailure)
            {
              emit(FailedToUpdateClubState(message: serverFailure.errorMessage));
            },
            (unit) async {
              await getAllClubs(userEntity: userEntity);
              emit(ClubUpdatedSuccessState());
            }
        )
    );
  }

  Set idForClubsIAskedToJoinAndWaitingResponse = {};
  Future<void> getIDForClubsIAskedForMembership({List? idForClubsMemberID,required String userID}) async {
    final clubUpdateResult = await sl<GetIDForClubsIAskedForMembershipUseCase>().execute(userID: userID,idForClubsMemberID: idForClubsMemberID);
    clubUpdateResult.fold(
        (serverFailure)
        {
          emit(FailedToGetIDForClubsIAskedForMembershipState(message: serverFailure.errorMessage));
        },
        (clubsID)
        {
          idForClubsIAskedToJoinAndWaitingResponse = clubsID;
          emit(GetIDForClubsIAskedForMembershipSuccessState());
        }
    );
  }

  void acceptOrRejectMembershipRequest({required LayoutCubit layoutCubit,required String receiverFirebaseToken,required String committeeNameForRequestSender,required String idForClubILead,required String requestSenderID,required String clubID,required bool respondStatus,required String clubName}) async {
    emit(AcceptOrRejectMembershipRequestLoadingState());
    final result = await sl<AcceptOrRejectMembershipRequestUseCase>().execute(committeeNameForRequestSender: committeeNameForRequestSender,clubID: clubID,requestSenderID: requestSenderID,respondStatus: respondStatus);
    result.fold(
            (serverFailure){
              emit(FailedToAcceptOrRejectMembershipRequestState(message: serverFailure.errorMessage));
            },
            (unit) async {
              await layoutCubit.sendNotification(toSpecificUserOrNumOfUsers: true,notifyTitle: "طلب العضوية",receiverFirebaseToken: receiverFirebaseToken,receiverID: requestSenderID, clubID: clubID, notifyContent: respondStatus ? "لقد تم قبول طلب العضوية في $clubName" : "لقد تم رفض طلب العضوية في $clubName", notifyType: respondStatus ? NotificationType.acceptYourMembershipRequest : NotificationType.rejectYourMembershipRequest);
              await getMembersDataOnMyClub(layoutCubit: layoutCubit, idForClubILead: idForClubILead);
              emit(AcceptOrRejectMembershipRequestSuccessState());
            }
    );
  }

  void removeMemberFromCLubILead({required String idForClubILead,required String memberID,required String memberFirebaseMessagingToken,required LayoutCubit layoutCubit,required String clubID,required String clubName}) async {
    emit(RemoveMemberFromClubLoadingState());
    final result = await sl<RemoveMemberFromClubILeadUseCase>().execute(memberID: memberID, clubID: idForClubILead);
    result.fold(
        (serverFailure)
        {
          emit(RemoveMemberFromClubWithFailureState(message: serverFailure.errorMessage));
        },
        (unit) async {
          await layoutCubit.sendNotification(toSpecificUserOrNumOfUsers: true,notifyTitle: "العضوية",receiverFirebaseToken: memberFirebaseMessagingToken,receiverID: memberID, notifyContent: "لقد تم إزالو عضويتك من نادي $clubName", notifyType: NotificationType.membershipRemoveFromSpecificClub, clubID: clubID);
          getMembersDataOnMyClub(layoutCubit: layoutCubit, idForClubILead: idForClubILead);
          emit(RemoveMemberFromClubSuccessState());
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