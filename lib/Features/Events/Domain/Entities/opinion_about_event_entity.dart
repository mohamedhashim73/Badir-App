import 'package:equatable/equatable.dart';

class OpinionAboutEventEntity extends Equatable {
  final String? opinion;
  final String? senderName;
  final String? eventName;

  const OpinionAboutEventEntity(this.opinion, this.senderName, this.eventName);

  @override
  // TODO: implement props
  List<Object?> get props => [opinion,senderName,eventName];
}