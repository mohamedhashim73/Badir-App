import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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
      await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).doc(newEventID.toString()).set(eventModel.toJson());
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