import 'package:bader_user_app/Features/Layout/Domain/Entities/notification_entity.dart';

class NotifyModel extends NotificationEntity {

  const NotifyModel(super.receiveDate,super.notifyType,super.fromAdmin,super.notifyMessage,super.clubID);

  // TODO: I didn't specify the type of json عشان في LayoutDataSource  بتجيلي الداتا في شكل object اللي هو Map يعني
  factory NotifyModel.fromJson({required json})
  {
    return NotifyModel(json['receiveDate'],json['notificationType'],json['fromAdmin'], json['notifyMessage'], json['clubID']);
  }

  Map<String,dynamic> toJson(){
    return {
      'notificationType' : super.notifyType,
      'fromAdmin' : super.fromAdmin,
      'notifyMessage' : super.notifyMessage,
      'clubID' : super.clubID,
      'receiveDate' : super.receiveDate
    };
  }
}