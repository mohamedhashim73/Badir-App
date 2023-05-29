import 'package:bader_user_app/Features/Clubs/Data/Models/member_model.dart';
import 'package:bader_user_app/Features/Events/Data/Models/request_authentication_on_task_model.dart';
import 'package:bader_user_app/Features/Events/Data/Models/task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/task_entity.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Errors/exceptions.dart';
import '../Models/event_model.dart';
import '../Models/opinion_about_event_model.dart';

class RemoteEventsDataSource{

  // TODO: use it during create or delete event ...
  Future<int> getNumOfEventsOnSpecificClub({required String clubID}) async {
    int eventsNum = 0;
    await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).get().then((value){
      eventsNum = value.data() != null  ? value.data()!['currentEventsNum'] ?? 0 : 0;
    });
    return eventsNum;
  }

  Future<Unit> createEvent({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    try
    {
      // TODO: Get Last ID For Last Event to increase it by one
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).get();
      int newEventID = querySnapshot.docs.isNotEmpty ? int.parse(querySnapshot.docs.last.id) : 0;
      ++newEventID;
      // TODO: Update CurrentEventsNum on this club
      int currentEventsNumOnThisClub = await getNumOfEventsOnSpecificClub(clubID: clubID);
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
        "currentEventsNum" : ++currentEventsNumOnThisClub
      });
      EventModel eventModel = EventModel(name, newEventID.toString(), description, imageUrl, startDate, endDate, time, forPublic.name, location, link, null, clubName, clubID);
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(newEventID.toString()).set(eventModel.toJson());
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> createTask({required String taskName,required String ownerID,required String clubID,required String description,String? eventID,String? eventName,required bool forPublicOrSpecificToAnEvent,required int hours,required int numOfPosition }) async {
    try
    {
      // TODO: Get Last ID For Last Task Created to increase it by one
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).get();
      int newTaskID = querySnapshot.docs.isNotEmpty ? int.parse(querySnapshot.docs.last.id) : 0;
      ++newTaskID;
      TaskModel taskModel = TaskModel(newTaskID,ownerID, taskName, description, hours, numOfPosition, 0, forPublicOrSpecificToAnEvent, eventName, clubID, eventID);
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(newTaskID.toString().trim()).set(taskModel.toJson());
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> updateEvent({required String eventID,required EventModel eventModel}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).update(eventModel.toJson());
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<UserEntity> getDataForSpecificUser({required String userID}) async {
    UserModel? userEntity;
    await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(userID).get().then((value){
      userEntity = UserModel.fromJson(json: value.data());
    });
    return userEntity!;
  }

  Future<Unit> joinToEvent({required String eventID,required String memberID}) async {
    try
    {
      UserEntity userEntity = await getDataForSpecificUser(userID: memberID);
      List idForEventsJoined = userEntity.idForEventsJoined ?? [];
      idForEventsJoined.add(eventID);   // TODO: add id for event in member Data on Firestore
      MemberModel member = MemberModel(memberName:userEntity.name!,memberID: memberID, membershipDate: Constants.getTimeNow());
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).collection(Constants.kMembersDataCollectionName).doc(memberID).set(member.toJson());
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(memberID).update({
        'idForEventsJoined' : idForEventsJoined
      });
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  // TODO: Get Members that on Event to Display them on its screen for ( Leader )
  Future<List<MemberModel>> getMembersForAnEvent({required String eventID}) async {
    try
    {
      List<MemberModel> members = [];
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).collection(Constants.kMembersDataCollectionName).get().then((value){
        debugPrint("Start getting data , documents length is ${value.docs.length}......");
        members = List<MemberModel>.of(value.docs.map((e) => MemberModel.fromJson(json: e.data())));
      });
      debugPrint("Members num : ${members.length}");
      return members;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> deleteEvent({required String eventID,required String clubID}) async {
    try
    {
      // TODO: Update CurrentEventsNum on this club
      int currentEventsNumOnThisClub = await getNumOfEventsOnSpecificClub(clubID: clubID);
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
        "currentEventsNum" : --currentEventsNumOnThisClub
      });
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).delete();
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> deleteTask({required String taskID}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskID).delete();
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  // TODO: All Events throw App not to specific Club
  Future<List<EventModel>> getAllEvents() async {
    try
    {
      List<EventModel> events = [];
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).get().then((value){
        for( var item in value.docs )
        {
          events.add(EventModel.fromJson(json: item.data()));
        }
      });
      return events;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  // TODO: All Events throw App not to specific Club
  Future<List<TaskModel>> getAllTasksOnApp() async {
    try
    {
      List<TaskModel> tasks = [];
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).get().then((value){
        for( var item in value.docs )
        {
          tasks.add(TaskModel.fromJson(json: item.data()));
        }
      });
      return tasks;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  Future<Unit> updateTask({required String taskID,required TaskModel taskModel}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskID).update(taskModel.toJson());
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  // TODO: ASK FOR Authentication on A Task
  Future<Unit> requestToAuthenticateOnATask({required String taskID,required String senderID,required String senderFirebaseFCMToken,required String senderName}) async {
    try
    {
      RequestAuthenticationOnATaskModel requestModel = RequestAuthenticationOnATaskModel(senderID,senderFirebaseFCMToken,senderName);
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskID).collection(Constants.kTaskAuthenticationRequestsCollectionName).doc(senderID).set(requestModel.toJson());
      return unit;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  Future<Unit> sendOpinionAboutEvent({required String eventID,required OpinionAboutEventModel opinionModel,required String senderID}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).collection(Constants.kOpinionsAboutTaskCollectionName).doc(senderID).set(opinionModel.toJson());
      return unit;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  Future<List<OpinionAboutEventModel>> getOpinionsAboutEvent({required String eventID}) async {
    try
    {
      List<OpinionAboutEventModel> opinions = [];
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).collection(Constants.kOpinionsAboutTaskCollectionName).get().then((value) async {
        for( var item in value.docs )
          {
            opinions.add(OpinionAboutEventModel.fromJson(json: item.data()));
          }
      });
      return opinions;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  // TODO: Leader ....
  Future<List<RequestAuthenticationOnATaskModel>> gedRequestForAuthenticateOnATask({required String taskID}) async {
    try
    {
      List<RequestAuthenticationOnATaskModel> requests = [];
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskID).collection(Constants.kTaskAuthenticationRequestsCollectionName).get().then((value){
        requests = List<RequestAuthenticationOnATaskModel>.of(value.docs.map((e) => RequestAuthenticationOnATaskModel.fromJson(json: e)));
      });
      return requests;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.message!);
    }
  }

  // TODO: هترجع id بتاع التاسكات اللي انا بعت طلب تسجيل فيها بالفعل
  Future<Set> getIDForTasksIAskedToAuthenticate({List? idForClubsIMemberIn,required String userID}) async {
    Set tasksID = {};
    await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).get().then((value) async {
      if( value.docs.isNotEmpty )
        {
          for( var item in value.docs )
          {
            if( item.data()['forPublicOrSpecificToAnEvent'] == true || ( idForClubsIMemberIn != null && idForClubsIMemberIn.contains(item.data()['clubID'].toString()) ) )
            {
              await item.reference.collection(Constants.kTaskAuthenticationRequestsCollectionName).get().then((value) async {
                for( var itemDoc in value.docs )
                {
                  if( itemDoc.id.trim() == userID.trim() ) tasksID.add(item.id);
                }
              });
            }
          }
        }
    });
    debugPrint("Num of Requests send to Tasks is : ${tasksID.length}");
    return tasksID;
  }

  // TODO: This method will get the number of members | use it when add new member to change its value on Members Number Collection
  Future<int> getTotalVolunteerHoursOnApp() async {
    int hours = 0;
    await FirebaseFirestore.instance.collection(Constants.kTotalVolunteerHoursThrowAppCollectionName).doc('Number').get().then((value){
      hours = value.data() != null  ? value.data()!['total'] : 0;
    });
    return hours;
  }

  // TODO: use it after leader accept user request to authenticate on a task
  Future<int> getTotalVolunteerHoursForSpecificClub({required String clubID}) async {
    int hours = 0;
    await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).get().then((value){
      hours = value.data() != null  ? value.data()!['volunteerHours'] ?? 0 : 0 ;
    });
    return hours;
  }

  Future<Unit> acceptOrRejectAuthenticateRequestOnATask({required String myID,required LayoutCubit layoutCubit,required String requestSenderName,required TaskEntity taskEntity,required String requestSenderID,required String requestFirebaseFCMToken,required bool respondStatus}) async {
    try
    {
      // TODO: ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskEntity.id.toString()).collection(Constants.kTaskAuthenticationRequestsCollectionName).doc(requestSenderID).delete();
      await layoutCubit.sendNotification(
          receiverID: requestSenderID,
          notifyTitle: "مصادقة المهام",
          toSpecificUserOrNumOfUsers: true,
          receiverFirebaseToken: requestFirebaseFCMToken,
          clubID: taskEntity.clubID,
          notifyContent: respondStatus ? "لقد تم قبول طلبك للمصادقة في مهمه ${taskEntity.name}" : "لقد تم رفض طلبك للمصادقة في مهمه ${taskEntity.name}",
          notifyType: respondStatus ? NotificationType.acceptYourRequestToAuthenticateOnATask : NotificationType.rejectYourRequestToAuthenticateOnATask
      );
      if( respondStatus )     // TODO: Request Accepted
      {
        // TODO: Update num of registered to Task
        int numOFRegisteredOnTask = taskEntity.numOfRegistered;
        await FirebaseFirestore.instance.collection(Constants.kTasksCollectionName).doc(taskEntity.id.toString()).update({
          'numOfRegistered' : ++numOFRegisteredOnTask,
        });
        // TODO: Get Data about RequestSender....
        DocumentSnapshot requestSenderDocumentSnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(requestSenderID).get();
        UserModel requestSenderUserModel = UserModel.fromJson(json: requestSenderDocumentSnapshot.data());
        List? idForTasksAuthenticate = requestSenderUserModel.idForTasksAuthenticate ?? [];
        int? volunteerHoursForUser = requestSenderUserModel.volunteerHours ?? 0;
        // TODO: Update volunteer num for User that he asked for authenticate .....
        volunteerHoursForUser += taskEntity.hours;    // TODO: هتضيف عدد ساعات التاسك للشخص ده
        idForTasksAuthenticate.add(taskEntity.id.toString().trim());
        await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(requestSenderID).update({
          'idForTasksAuthenticate' : idForTasksAuthenticate,
          'volunteerHours' : volunteerHoursForUser,
        });
        // TODO: Update total volunteer num on The App
        int totalVolunteerHours = await getTotalVolunteerHoursOnApp();
        totalVolunteerHours += taskEntity.hours;
        await FirebaseFirestore.instance.collection(Constants.kTotalVolunteerHoursThrowAppCollectionName).doc('Number').set({
          'total' : totalVolunteerHours
        });
        // TODO: Update volunteer num on The Club that have this Task .....
        int volunteerHoursForClub = await getTotalVolunteerHoursForSpecificClub(clubID: taskEntity.clubID);
        volunteerHoursForClub += taskEntity.hours;
        await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(taskEntity.clubID).update({
          'volunteerHours' : volunteerHoursForClub,

        });
      }
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }


}