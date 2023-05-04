import '../../Domain/Entities/task_entity.dart';

class TaskModel extends TaskEntity{

  const TaskModel(super.id, super.description, super.hours, super.numOfPosition, super.states, super.clubName, super.clubID);

  factory TaskModel.fromJson({required Map<String,dynamic> json})
  {
    return TaskModel(json['id'], json['description'], json['hours'], json['numOfPosition'], json['states'], json['clubName'], json['clubID']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id' : super.id,
      'description' : super.description,
      'states' : super.states,
      'numOfPosition' : super.numOfPosition,
      'hours' : super.hours,
      'clubID' : super.clubID,
      'clubName' : super.clubName,
    };
  }

}