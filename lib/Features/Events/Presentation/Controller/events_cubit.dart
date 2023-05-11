import 'dart:io';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/delete_event_use_case.dart';
import 'package:jiffy/jiffy.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/add_event_use_case.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
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

  // TODO: USE IT TO FILTER EVENTS TO NEW AND PAST
  List<EventEntity> pastEvents = [];
  List<EventEntity> newEvents = [];
  List<EventEntity> ownEvents = [];      // TODO: Mean that created by me | Related Club That I lead
  List<EventEntity> allEvents = [];
  Future<void> getAllEvents() async {
    emit(GetEventsLoadingState());
    final result = await sl<GetAllEventsUseCase>().execute();
    result.fold(
            (serverFailure){
              allEvents.clear();
              emit(FailedToGetEventsDataState(message: serverFailure.errorMessage));
            },
            (eventsData) async {
              allEvents = eventsData;
              await getPastAndNewEvents();
              debugPrint("Past Events Number is : ${pastEvents.length}");
              debugPrint("New Events Number is : ${newEvents.length}");
              emit(GetEventsDataSuccessState());
        }
    );
  }

  Future<void> getPastAndNewEvents() async {
    ownEvents.clear();
    for( int i = 0 ; i < allEvents.length ; i++ )
    {
      DateTime eventDate = Jiffy("${allEvents[i].endDate!.trim()} ${allEvents[i].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
      if (DateTime.now().isAfter(eventDate))
      {
        pastEvents.add(allEvents[i]);
      }
      else
      {
        newEvents.add(allEvents[i]);
      }
    }
  }

  Future<void> getEventsCreatedByMe({required String idForClubThatYouLead}) async {
    for( int i = 0 ; i < allEvents.length ; i++ )
    {
      if( allEvents[i].clubID == idForClubThatYouLead )
        {
          ownEvents.add(allEvents[i]);
        }
    }
    emit(GetEventsCreatedByMeSuccessState());
  }

  void createEvent({required LayoutCubit layoutCubit,required EventForPublicOrNot forPublic,required String name,required String description,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    emit(CreateEventLoadingState());
    // TODO: Upload Image to Storage, get link
    String? imageUrl = await layoutCubit.uploadImageToStorage(imgFile: eventImage!);
    if( imageUrl != null )
      {
        final result = await sl<CreateEventUseCase>().execute(forPublic: forPublic, name: name, description: description, imageUrl: imageUrl, startDate: startDate, endDate: endDate, time: time, location: location, link: link, clubID: clubID, clubName: clubName);
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

  void deleteEvent({required String eventID,required String idForClubILead}) async {
    emit(DeleteEventLoadingState());
    final result = await sl<DeleteEventUseCase>().execute(eventID: eventID);
    result.fold(
            (serverFailure){
                emit(FailedToDeleteEventState(message: serverFailure.errorMessage));
            },
            (unit) async
            {
              await getEventsCreatedByMe(idForClubThatYouLead: idForClubILead);
              await getAllEvents();    // TODO: as it updated
              emit(DeleteEventSuccessState());
            }
    );
  }
}