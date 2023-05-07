import 'dart:io';
import 'dart:math';

import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Events/Data/Models/event_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/add_event_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../Domain/Entities/event_entity.dart';
import '../../Domain/Use_Cases/get_all_events_use_case.dart';
import 'events_states.dart';

class EventsCubit extends Cubit<EventsStates> {
  EventsCubit() : super(EventsInitialState());

  static EventsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: Get Notifications
  List<EventEntity> allEvents = [];
  Future<void> getAllEvents() async {
    emit(GetEventsLoadingState());
    final result = await sl<GetAllEventsUseCase>().execute();
    result.fold(
            (serverFailure){
              allEvents.clear();
              emit(FailedToGetEventsDataState(message: serverFailure.errorMessage));
            },
            (eventsData){
              allEvents = eventsData;
              debugPrint("Events Number is : ${eventsData.length}");
              emit(GetEventsDataSuccessState());
            }
    );
  }

  void createEvent({required LayoutCubit layoutCubit,required EventForPublicOrNot forPublic,required String name,required String description,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    emit(CreateEventLoadingState());
    // TODO: Upload Image to Storage, get link
    String? imageUrl = await layoutCubit.uploadImageToStorage(imgFile: eventImage!);
    if( imageUrl != null )
      {
        final result = await sl<CreateEventUseCase>().execute(forPublic: forPublic, name: name, description: description, imageUrl: imageUrl!, startDate: startDate, endDate: endDate, time: time, location: location, link: link, clubID: clubID, clubName: clubName);
        result.fold(
                (serverFailure){
              emit(FailedToCreateEventState(message: serverFailure.errorMessage));
            },
                (unit) async {
              await getAllEvents();    // TODO: as it updated
              emit(CreateEventSuccessState());
            }
        );
      }
    else
      {
        FailedToCreateEventState(message: "حدثت مشكله اثناء رفع الصورة برجاء المحاوله لاحقا");
      }
  }

  List<EventEntity> ownEventsData = [];
  void getEventsRelatedToYourOwnClub({required String idForClubYouLead}) async {
    ownEventsData = allEvents.where((element) => element.clubID == idForClubYouLead).toList();
    emit(GetEventsForYourOwnClubSuccessState());
  }

  File? eventImage;
  void getEventImage() async {
    XFile? pickedImage = await Constants.getImageFromGallery();
    if( pickedImage != null )
      {
        eventImage = File(pickedImage.path);
        emit(GetEventImageFromGallerySuccessState());
      }
    else
      {
        emit(FailedToGetEventImageFromGalleryState());
      }
  }

  EventForPublicOrNot eventForPublic = EventForPublicOrNot.private;
  void chooseEventForPublicOrNot({required EventForPublicOrNot value}) {
    eventForPublic = value;
    emit(EventForPublicOrNotSelectedSuccessState());
  }
}