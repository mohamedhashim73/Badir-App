import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Use_Cases/get_all_clubs_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../Domain/Use_Cases/request_membership_use_case.dart';
import 'clubs_states.dart';

class ClubsCubit extends Cubit<ClubsStates> {
  ClubsCubit() : super(ClubsInitialState());

  static ClubsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<ClubEntity> clubs = [];
  void getClubsData() async {
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
    filteredClubsData = clubs.where((element) => element.name.toLowerCase().contains(input.toLowerCase())).toList();
    emit(GetFilteredClubsSuccessStatus());
  }
}