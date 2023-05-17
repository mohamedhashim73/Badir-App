import '../../Domain/Entities/task_entity.dart';

class TaskModel extends TaskEntity{

  const TaskModel(super.id,super.ownerID, super.name, super.description, super.hours, super.numOfPosition,super.numOfRegistered, super.forPublicOrSpecificToAnEvent, super.eventName, super.clubID, super.eventID);

  factory TaskModel.fromJson({required Map<String,dynamic> json})
  {
    return TaskModel(json['id'],json['ownerID'], json['name'],json['description'], json['hours'], json['numOfPosition'], json['numOfRegistered'], json['forPublicOrSpecificToAnEvent'], json['eventName'], json['clubID'], json['eventID']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id' : super.id,
      'ownerID' : super.ownerID,
      'name' : super.name,
      'description' : super.description,
      'forPublicOrSpecificToAnEvent' : super.forPublicOrSpecificToAnEvent,
      'numOfPosition' : super.numOfPosition,
      'numOfRegistered' : super.numOfRegistered,
      'hours' : super.hours,
      'clubID' : super.clubID,
      'eventID' : super.eventID,
      'eventName' : super.eventName,
    };
  }

}