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
  // TODO: انا عامل idForClubILead مش required لأن هستعمله في حاله اذا كان المستخدم ده بالفعل ليدر ف هحتاج اباصيه عشان اسند الفعاليات اللي هو انشأها لل List بتاعته واللي هيا ownEvents
  Future<void> getAllEvents({String? idForClubILead}) async {
    emit(GetEventsLoadingState());
    final result = await sl<GetAllEventsUseCase>().execute();
    result.fold(
            (serverFailure){
              allEvents.clear();
              emit(FailedToGetEventsDataState(message: serverFailure.errorMessage));
            },
            (eventsData) async {
              allEvents = eventsData;
              await getPastAndNewAndMyEvents(idForClubILead: idForClubILead);   // TODO: Notice that id not required...
              debugPrint("Past Events Number is : ${pastEvents.length}");
              debugPrint("New Events Number is : ${newEvents.length}");
              emit(GetEventsDataSuccessState());
        }
    );
  }

  Future<void> getPastAndNewAndMyEvents({String? idForClubILead}) async {
    ownEvents.clear();
    debugPrint("All Events number is : ${allEvents.length}");
    if( idForClubILead != null ) emit(EventsClassifiedLoadingState());  // TODO: لأن هستعملها فقط في صفحه اداره الفعاليات عشان اعمل CircleProgressIndicator()
    for( int i = 0 ; i < allEvents.length ; i++ )
    {
      // TODO: OWN EVENTS will be shown on events management Screen
      if( idForClubILead != null && allEvents[i].clubID == idForClubILead )
        {
          ownEvents.add(allEvents[i]);
        }
      // TODO: Classify Events to Old or New
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
    emit(EventsClassifiedSuccessState());
  }

  void createEvent({required LayoutCubit layoutCubit,required EventForPublicOrNot forPublic,required String name,required String description,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    emit(CreateEventLoadingState());
    // TODO: Upload Image to Storage, get link
    String? imageUrl = await layoutCubit.uploadFileToStorage(file: eventImage!);
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
            (serverFailure)
            {
              emit(FailedToDeleteEventState(message: serverFailure.errorMessage));
            },
            (unit) async
            {
              await getAllEvents(idForClubILead: idForClubILead);    // TODO: as it updated
              emit(DeleteEventSuccessState());
            }
    );
  }
}