import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Clubs_UseCases/get_all_clubs_use_case.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../Domain/UseCases/Clubs_UseCases/request_membership_use_case.dart';
import 'clubs_states.dart';

class ClubsCubit extends Cubit<ClubsStates> {
  ClubsCubit() : super(ClubsInitialState());

  static ClubsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<ClubEntity> clubs = [];
  void getClubsData() async {
    emit(GetClubsLoadingState());
    final result = await GetAllClubsUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute();
    result.fold(
            (l){
              clubs.clear();
              emit(FailedToGetClubsDataState(message: l.message));
            },
            (r){
              clubs = r;
              debugPrint("Clubs Number is : ${r.length}");
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
  void askForMembership({required String clubID,required String infoAboutAsker,required String requestUserName}) async {
    emit(SendRequestForMembershipLoadingState());
    bool sendRequest = await RequestAMembershipUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute(clubID: clubID, userAskForMembershipID: Constants.userID!, infoAboutAsker: infoAboutAsker, committeeName: selectedCommittee!,requestUserName: requestUserName);
    sendRequest ? emit(SendRequestForMembershipSuccessState()) : emit(FailedToSendRequestForMembershipState());
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