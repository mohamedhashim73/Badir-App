import 'package:bader_user_app/Features/Clubs/Data/Models/member_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Errors/exceptions.dart';
import '../Models/event_model.dart';

class RemoteEventsDataSource{

  Future<Unit> createEvent({required EventForPublicOrNot forPublic,required String name,required String description,required String imageUrl,required String startDate,required String endDate,required String time,required String location,required String link,required String clubID,required String clubName}) async {
    try
    {
      // TODO: Get Last ID For Last Event to increase it by one
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).get();
      int newEventID = querySnapshot.docs.isNotEmpty ? int.parse(querySnapshot.docs.last.id) : 0;
      ++newEventID;
      EventModel eventModel = EventModel(name, newEventID.toString(), description, imageUrl, startDate, endDate, time, forPublic.name, location, link, null, clubName, clubID);
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(newEventID.toString().trim()).set(eventModel.toJson());
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

  Future<Unit> deleteEvent({required String eventID}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(eventID).delete();
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
      throw ServerException(exceptionMessage: e.code);
    }
  }

}