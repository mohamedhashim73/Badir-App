import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';

class SendNotificationUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  SendNotificationUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, Unit>> execute({required String notifyTitle,required bool toSpecificUserOrNumOfUsers,String? topicName,String? receiverFirebaseToken,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    return await layoutBaseRepository.sendNotification(notifyTitle: notifyTitle,toSpecificUserOrNumOfUsers: toSpecificUserOrNumOfUsers,topicName: topicName,receiverFirebaseToken:receiverFirebaseToken,receiverID: receiverID, clubID: clubID, notifyContent: notifyContent, notifyType: notifyType);
  }

}