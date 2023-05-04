import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../Domain/Entities/event_entity.dart';
import '../../Domain/Use_Cases/get_all_events_use_case.dart';
import 'events_states.dart';

class EventsCubit extends Cubit<EventsStates> {
  EventsCubit() : super(EventsInitialState());

  static EventsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<EventEntity> events = [];
  void getEventsData() async {
    emit(GetEventsLoadingState());
    final result = await sl<GetAllEventsUseCase>().execute();
    result.fold(
            (serverFailure){
              events.clear();
              emit(FailedToGetEventsDataState(message: serverFailure.errorMessage));
            },
            (r){
              events = r;
              debugPrint("Events Number is : ${r.length}");
              emit(GetEventsDataSuccessState());
            }
    );
  }

}