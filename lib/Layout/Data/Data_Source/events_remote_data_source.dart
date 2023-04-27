import 'package:bader_user_app/Layout/Data/Models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Core/Constants/constants.dart';

class EventsRemoteDataSource{
  // TODO: Include everything related to Events

  // TODO: Get Clubs from Firestore
  Future<List<EventModel>> getEvents() async {
    List<EventModel> events = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).get();
    for( var item in querySnapshot.docs )
    {
      events.add(EventModel.fromJson(json: item.data()));
    }
    return events;
  }

}