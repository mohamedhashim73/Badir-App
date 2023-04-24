import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Layout/Data/Repositories/layout_imply_repository.dart';
import 'package:bader_user_app/Layout/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Layout/Domain/UseCases/Events_UseCases/get_all_events_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'events_states.dart';

class EventsCubit extends Cubit<EventsStates> {
  EventsCubit() : super(EventsInitialState());

  static EventsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<EventEntity> events = [];
  void getEventsData() async {
    emit(GetEventsLoadingState());
    final result = await GetAllEventsUseCase(layoutBaseRepository: sl<LayoutRemoteImplyRepository>()).execute();
    result.fold(
            (l){
              events.clear();
              emit(FailedToGetEventsDataState(message: l.message));
            },
            (r){
              events = r;
              debugPrint("Events Number is : ${r.length}");
              emit(GetEventsDataSuccessState());
            }
    );
  }

}