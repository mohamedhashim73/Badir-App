import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? notifyType;   // ممكن في تطبيق المستخدم هتشك علي نوعها لو هي ان اصبحت ليدر هستدعي الداله اللي بتجيب الداتا بتاعتي وف نفس الوقت الداتا بتاع النادي اللي انا قائد عليه
  final bool? fromAdmin;
  final String? receiveDate;
  final String? notifyMessage;
  final String? clubID;        // Todo: optional as it will have value if Admin ask user to be a leader for a specific CLub

  const NotificationEntity(this.receiveDate,this.notifyType,this.fromAdmin, this.notifyMessage, this.clubID);

  @override
  // TODO: implement props
  List<Object?> get props => [notifyType,fromAdmin,notifyMessage,clubID,receiveDate];

}