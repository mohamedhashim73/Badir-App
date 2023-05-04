import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Errors/exceptions.dart';
import '../Models/event_model.dart';

class RemoteEventsDataSource{

  Future<List<EventModel>> getEvents() async {
    try{
      List<EventModel> events = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kEventsCollectionName).get();
      for( var item in querySnapshot.docs )
      {
        events.add(EventModel.fromJson(json: item.data()));
      }
      return events;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

}