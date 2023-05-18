import '../../Domain/Entities/opinion_about_event_entity.dart';

class OpinionAboutEventModel extends OpinionAboutEventEntity{
  const OpinionAboutEventModel(super.opinion,super.senderName,super.eventName);

  factory OpinionAboutEventModel.fromJson({required json}) => OpinionAboutEventModel(json['opinion'], json['senderName'], json['eventName']);

  Map<String,dynamic> toJson(){
    return {
      'opinion' : super.opinion,
      'senderName' : super.senderName,
      'eventName' : super.eventName,
    };
  }

}