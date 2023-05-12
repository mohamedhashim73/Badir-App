import '../../Domain/Entities/meeting_entity.dart';

class MeetingModel extends MeetingEntity{
  const MeetingModel(super.name, super.id, super.description,super.startDate, super.endDate, super.time,super.location,super.link);

  // Json == Map<String,dynamic>
  factory MeetingModel.fromJson({required json})
  {
    return MeetingModel(json['name'], json['id'], json['description'],json['startDate'], json['endDate'], json['time'], json['location'], json['link']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'description' : super.description,
      'id' : super.id,
      'startDate' : super.startDate,
      'endDate' : super.endDate,
      'time' : super.time,
      'location' : super.location,
      'link' : super.link,
    };
  }
}