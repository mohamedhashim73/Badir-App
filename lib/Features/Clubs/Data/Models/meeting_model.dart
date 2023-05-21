import '../../Domain/Entities/meeting_entity.dart';

class MeetingModel extends MeetingEntity{
  const MeetingModel(super.name, super.id,super.description,super.date, super.time,super.location,super.link);

  // Json == Map<String,dynamic>
  factory MeetingModel.fromJson({required json})
  {
    return MeetingModel(json['name'], json['id'], json['description'],json['date'], json['time'], json['location'], json['link']);
  }

  Map<String,dynamic> toJson(){
    return {
      'name' : super.name,
      'description' : super.description,
      'id' : super.id,
      'date' : super.date,
      'time' : super.time,
      'location' : super.location,
      'link' : super.link,
    };
  }
}