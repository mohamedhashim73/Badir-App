import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Clubs_UseCases/get_all_clubs_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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

}