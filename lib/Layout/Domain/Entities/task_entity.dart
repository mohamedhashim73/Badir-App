import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable{
  final String id;
  final String description;
  final int hours;
  final int numOfPosition;
  final bool states;
  final String clubName;
  final String clubID;


  const TaskEntity(this.id, this.description, this.hours, this.numOfPosition, this.states, this.clubName, this.clubID);

  @override
  // TODO: implement props
  List<Object?> get props => [id,description,hours,numOfPosition,states,clubName,clubID];
}