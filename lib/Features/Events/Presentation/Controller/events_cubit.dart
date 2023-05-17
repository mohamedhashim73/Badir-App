import 'dart:io';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/member_entity.dart';
import 'package:bader_user_app/Features/Events/Data/Models/event_model.dart';
import 'package:bader_user_app/Features/Events/Data/Models/task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/create_task_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/delete_event_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/delete_task_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_all_tasks_on_app_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_id_for_tasks_that_i_asked_for_authentication.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/get_members_on_an_event_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/join_to_event_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/request_authenticate_on_task_use_case.dart';
import 'package:bader_user_app/Features/Events/Domain/Use_Cases/update_event_use_case.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
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
import '../../Domain/Entities/task_entity.dart';
import '../../Domain/Use_Cases/get_all_events_use_case.dart';
import '../../Domain/Use_Cases/update_task_use_case.dart';
import 'events_states.dart';

class EventsCubit extends Cubit<EventsStates> {
  EventsCubit() : super(EventsInitialState());

  static EventsCubit getInstance(BuildContext context) => BlocProvider.of(context);

  // TODO: USE IT TO FILTER EVENTS TO NEW AND PAST
  List<EventEntity> pastEvents = [];
  List<EventEntity> newEvents = [];
  List<EventEntity> ownEvents = [];      // TODO: Mean that created by me | Related Club That I lead
  List<String> namesForEventsICreated = [];      // TODO: Mean that created by me | Related Club That I lead  هستعملها في حاله انشاء تاسك مع DropDownButton
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

  // TODO: related to Leader....
  List<MemberEntity> membersDataForAnEvent = [];
  Future<void> getMembersOnAnEvent({required String eventID}) async {
    emit(GetMemberOnAnEventLoadingState());
    final result = await sl<GetMembersOnAnEventUseCase>().execute(eventID: eventID);
    result.fold(
        (serverFailure){
          emit(FailedToGetMembersOnAnEventDataState(message: serverFailure.errorMessage));
        },
        (members) async {
          membersDataForAnEvent = members;
          debugPrint("Members num on this Event is : ${members.length}");
          emit(GetMembersOnAnEventSuccessState());
        }
    );
  }

  // TODO: related to Leader....
  void updateEvent({required LayoutCubit layoutCubit,required String mainImageUrl,required String eventID,required String name,required EventForPublicOrNot forPublic,required String description,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    emit(UpdateEventLoadingState());
    String? imgUrl ;
    if( eventImage != null )
      {
        imgUrl = await layoutCubit.uploadFileToStorage(file: eventImage!);
      }
    EventModel eventModel = EventModel(name, eventID, description, imgUrl ?? mainImageUrl, startDate, endDate, time, forPublic.name, location, link, null, clubName, clubID);
    final result = await sl<UpdateEventUseCase>().execute(eventID: eventID,eventModel:eventModel);
    result.fold(
        (serverFailure)
        {
          emit(FailedToUpdateEventState(message: serverFailure.errorMessage));
        },
        (unit) async
        {
          await getAllEvents(idForClubILead: clubID);
          emit(UpdateEventSuccessState());
        }
    );
  }

  // TODO: for Leader and Visitor ( make idForClubILead optional as in View Events i want only pastEvents and new but on Events Management i want my Eevnts mean that created by me ) .....
  Future<void> getPastAndNewAndMyEvents({String? idForClubILead}) async {
    ownEvents.clear();
    newEvents.clear();
    pastEvents.clear();
    namesForEventsICreated.clear();
    debugPrint("All Events number is : ${allEvents.length}");
    if( idForClubILead != null ) emit(EventsClassifiedLoadingState());  // TODO: لأن هستعملها فقط في صفحه اداره الفعاليات عشان اعمل CircleProgressIndicator()
    for( int i = 0 ; i < allEvents.length ; i++ )
    {
      DateTime eventDate = Jiffy("${allEvents[i].endDate!.trim()} ${allEvents[i].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
      if( idForClubILead != null && allEvents[i].clubID == idForClubILead )
        {
          namesForEventsICreated.add(allEvents[i].name!);
          ownEvents.add(allEvents[i]);
        }
      DateTime.now().isAfter(eventDate) ? pastEvents.add(allEvents[i]) : newEvents.add(allEvents[i]);
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

  List<String> taskOptionsForCreateIt = [];   // TODO: include names of eventsName that create by me + forPublic
  Future<void> getNamesOfEventsToUseInCreatingTask({required String idForClubILead}) async {
    taskOptionsForCreateIt.clear();
    if( ownEvents.isEmpty ) await getPastAndNewAndMyEvents(idForClubILead: idForClubILead);  // TODO: عشان هستعمل ownEvents
    for ( var element in ownEvents ) { taskOptionsForCreateIt.add(element.name!); }
    taskOptionsForCreateIt.add("للعامة");
    emit(GetNamesOfEventsToUseInOptionsForCreatingTaskState());
  }

  // TODO: ف حاله ان التاسك تبع فعاليه معينه وهو اختار فعاليه مثلا هروح اجيب الداتا بتاعتها بناء علي اسم الفعاليه اللي اختاره من ال DropdownButton
  Future<EventEntity> getEventDataThrowItsNameToUseItForCreatingTask({required String eventName}) async {
    return ownEvents.firstWhere((eventItem) => eventItem.name!.trim() == eventName.trim());
  }

  String? eventNameForTaskCreated;
  void chooseEventNameForTaskCreated({required String value}) {
    eventNameForTaskCreated = value;
    emit(ChooseEventNameForTaskCreatedState());
  }

  void createTask({required String taskName,required int hours,required String idForClubILead,required String ownerID,required int numOfPosition,required String description,required bool taskForPublicOrSpecificEvent}) async {
    // TODO: taskForPublicOrSpecificEvent => هجيب قيمتها م خلال ان هشك علي القيمه المختاره لو هي موجوده في id بتاع الفعاليات اللي انسأتها ولا لا
    emit(CreateTaskLoadingState());
    EventEntity? eventEntitySelectedForTask;
    if( taskForPublicOrSpecificEvent == false ) eventEntitySelectedForTask = await getEventDataThrowItsNameToUseItForCreatingTask(eventName: eventNameForTaskCreated!);
    final result = await sl<CreateTaskUseCase>().execute(ownerID:ownerID,taskName: taskName,clubID: idForClubILead,eventID: eventEntitySelectedForTask?.id,eventName: eventEntitySelectedForTask?.name,description: description, forPublicOrSpecificToAnEvent: taskForPublicOrSpecificEvent, hours: hours, numOfPosition: numOfPosition);
    result.fold(
            (serverFailure)
            {
              emit(FailedCreateTaskState(message: serverFailure.errorMessage));
            },
            (unit) async
            {
              // TODO: Get All Tasks .....
              await getAllTasksOnApp();
              await getTasksCreatedByMe(idForClubILead: idForClubILead);
              emit(CreateTaskSuccessState());
            }
    );
  }

  void joinToEvent({required String eventID,required LayoutCubit layoutCubit,required String memberID}) async {
    emit(JoinToEventLoadingState());
    final result = await sl<JoinToEventUseCase>().execute(eventID: eventID, memberID: memberID);
    result.fold(
        (serverFailure)
        {
          emit(FailedToJoinToEventState(message: serverFailure.errorMessage));
        },
        (unit) async
        {
          await layoutCubit.getMyData();   // TODO: لأن حصل في تعديل في الداتا بتاعته وخصوصا في idForEventsJoined
          emit(JoinToEventSuccessState());
        }
    );
  }

  List<TaskEntity> allTasksOnApp = [];
  Future<void> getAllTasksOnApp() async {
    emit(GetAllTasksOnAppLoadingState());
    final result = await sl<GetAllTasksOnAppUseCase>().execute();
    result.fold(
        (serverFailure)
        {
          emit(FailedToGetAllTasksOnAppState(message: serverFailure.errorMessage));
        },
        (tasks) async
        {
          allTasksOnApp = tasks;
          emit(GetAllTasksOnAppSuccessState());
        }
    );
  }

  // TODO: Get Tasks for Members .... ( ده ناقص اعملها )
  List<TaskEntity> tasksCreatedByMe = [];
  Future<void> getTasksCreatedByMe({required String idForClubILead}) async {
    tasksCreatedByMe.clear();
    emit(GetTasksThatCreatedByMeLoadingState());
    for( var item in allTasksOnApp )
    {
      if( item.ownerID == Constants.userID || ( item.clubID.trim() == idForClubILead.trim() ) )
      {
        tasksCreatedByMe.add(item);
      }
    }
    emit(GetTasksThatCreatedByMeSuccessState());
  }

  // TODO: Get Tasks for Ordinary User or Member not Leader .....
  List<TaskEntity> availableTasks = [];
  Future<void> getAvailableTasks({required UserEntity myData}) async {
    availableTasks.clear();
    debugPrint("All Tasks on App length : ${allTasksOnApp.length}");
    emit(GetAvailableTasksLoadingState());
    if( allTasksOnApp.isEmpty ) await getAllTasksOnApp();
    for( var item in allTasksOnApp )
    {
      if( item.forPublicOrSpecificToAnEvent || ( myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(item.clubID)) )   // Public or related to club i'm member on it...
      {
        availableTasks.add(item);
      }
    }
    await getIDForTasksIAskedToAuthenticate(userID: myData.id!,idForClubsIMemberIn: myData.idForClubsMemberIn);   // TODO: عشان بس لو بعت طلب اظهر للمستخد انه تم ارسال طلب عشان ميبعتش تاني
    emit(GetAvailableTasksSuccessState());
  }

  void deleteTask({required String taskID,required String idForClubILead}) async {
    emit(DeleteTaskLoadingState());
    final result = await sl<DeleteTaskUseCase>().execute(taskID: taskID);
    result.fold(
        (serverFailure)
        {
          emit(FailedToDeleteTaskState(message: serverFailure.errorMessage));
        },
        (unit) async
        {
          await getAllTasksOnApp();
          await getTasksCreatedByMe(idForClubILead: idForClubILead);
          emit(DeleteTaskSuccessState());
        }
    );
  }

  // TODO: User or Member ....
  void requestAuthenticateOnATask({required String taskID,required String senderID,required String senderName}) async {
    emit(RequestAuthenticateOnATaskLoadingState());
    final result = await sl<RequestAuthenticationOnATaskUseCase>().execute(taskID: taskID, senderID: senderID, senderName: senderName);
    result.fold(
        (serverFailure)
        {
          emit(FailedToRequestAuthenticateOnATaskState(message: serverFailure.errorMessage));
        },
        (unit)
        {
          emit(RequestAuthenticateOnATaskSuccessState());
        }
    );
  }

  Set? idForTasksThatIAskedToAuthenticateBefore;
  // TODO: هترجع id بتاع التاسكات اللي انا بعت طلب تسجيل فيها بالفعل  -- Call it after call getAvailableTasks()
  Future<void> getIDForTasksIAskedToAuthenticate({List? idForClubsIMemberIn,required String userID}) async {
    emit(RequestAuthenticateOnATaskLoadingState());
    final result = await sl<GetIDForTasksThatIAskedForAuthenticationBeforeUseCase>().execute(userID: userID,idForClubIMemberIn: idForClubsIMemberIn);
    result.fold(
        (serverFailure)
        {
          emit(FailedToGetIDForTasksIAskedToAuthenticateState(message: serverFailure.errorMessage));
        },
        (tasksID)
        {
          idForTasksThatIAskedToAuthenticateBefore = tasksID;
          emit(GetIDForTasksIAskedToAuthenticateSuccessState());
        }
    );
  }

  void updateTask({required int taskID,required String taskName,required String clubID,required int hours,required String idForClubILead,required String ownerID,required int numOfPosition,required int numOfRegistered,required String description,required bool taskForPublicOrSpecificEvent}) async {
    // TODO: taskForPublicOrSpecificEvent => هجيب قيمتها م خلال ان هشك علي القيمه المختاره لو هي موجوده في id بتاع الفعاليات اللي انسأتها ولا لا
    emit(UpdateTaskLoadingState());
    EventEntity? eventEntitySelectedForTask;
    if( taskForPublicOrSpecificEvent == false ) eventEntitySelectedForTask = await getEventDataThrowItsNameToUseItForCreatingTask(eventName: eventNameForTaskCreated!);
    TaskModel taskModel = TaskModel(taskID, ownerID, taskName, description, hours, numOfPosition, numOfRegistered, taskForPublicOrSpecificEvent, eventEntitySelectedForTask?.name, clubID, eventEntitySelectedForTask?.id);
    final result = await sl<UpdateTaskUseCase>().execute(taskID: taskID.toString(), taskModel: taskModel);
    result.fold(
        (serverFailure)
        {
          emit(FailedToUpdateTaskState(message: serverFailure.errorMessage));
        },
            (unit) async
        {
          // TODO: Get All Tasks .....
          await getAllTasksOnApp();
          await getTasksCreatedByMe(idForClubILead: idForClubILead);
          emit(UpdateTaskSuccessState());
        }
    );
  }

}