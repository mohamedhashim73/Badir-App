import 'package:equatable/equatable.dart';

class EventEntity extends Equatable{
  final String? name;
  final String? id;
  final String? description;
  final String? image;
  final String? startDate;
  final String? endDate;
  final String? time;
  final String? forPublic;
  final String? location;
  final String? link;
  final List? speakers;
  final String? clubName;
  final String? clubID;

  const EventEntity(
      this.name,
      this.id,
      this.description,
      this.image,
      this.startDate,
      this.endDate,
      this.time,
      this.forPublic,
      this.location,
      this.link,
      this.speakers,
      this.clubName,
      this.clubID
      );

  @override
  // TODO: implement props
  List<Object?> get props => [name,id,description,image,startDate,endDate,time,forPublic,location,link,speakers,clubName,clubID];
}