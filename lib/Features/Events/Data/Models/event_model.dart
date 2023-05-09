import '../../Domain/Entities/event_entity.dart';

class EventModel extends EventEntity{
  const EventModel(super.name, super.id, super.description, super.image, super.startDate, super.endDate, super.time, super.forPublic, super.location, super.link, super.speakers, super.clubName, super.clubID);

  // Json == Map<String,dynamic>
  factory EventModel.fromJson({required json})
  {
    return EventModel(json['name'], json['id'], json['description'], json['image'], json['startDate'], json['endDate'], json['time'], json['forPublic'], json['location'], json['link'],json['speakers'], json['clubName'], json['clubID']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'description' : super.description,
      'id' : super.id,
      'link' : super.link,
      'image' : super.image,
      'forPublic' : super.forPublic,
      'startDate' : super.startDate,
      'endDate' : super.endDate,
      'time' : super.time,
      'location' : super.location,
      'speakers' : super.speakers,
      'clubID' : super.clubID,
      'clubName' : super.clubName,
    };
  }
}