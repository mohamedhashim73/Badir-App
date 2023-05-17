import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable{
  final int id;
  final String name;
  final String ownerID;     // TODO: Leader ID That create it .....
  final String description;
  final int hours;
  final int numOfPosition;
  final int numOfRegistered;
  final bool forPublicOrSpecificToAnEvent;      // TODO: in both cases will have a value.....
  final String? eventName;  // TODO: Have value if it related to an event
  final String clubID ;     // TODO: Have value if it related to an event
  final String? eventID;   // TODO: Have value if it related to an event


  const TaskEntity(this.id,this.ownerID, this.name, this.description, this.hours, this.numOfPosition,this.numOfRegistered, this.forPublicOrSpecificToAnEvent, this.eventName, this.clubID, this.eventID);

  @override
  // TODO: implement props
  List<Object?> get props => [id,ownerID,name,description,hours,numOfPosition,numOfRegistered,forPublicOrSpecificToAnEvent,eventName,clubID,eventID];
}