import 'package:equatable/equatable.dart';

class MeetingEntity extends Equatable{
  final String? name;
  final String? id;
  final String? description;
  final String? date;
  final String? time;
  final String? location;
  final String? link;

  const MeetingEntity(
      this.name,
      this.id,
      this.description,
      this.date,
      this.time,
      this.location,
      this.link,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,description,date,time,location,link];
}