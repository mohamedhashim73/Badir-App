import 'dart:io';

import 'package:bader_user_app/Features/Layout/Domain/Entities/notification_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Errors/failure.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../Presentation/Controller/layout_cubit.dart';
import '../Entities/user_entity.dart';

// TODO: Contract Repository
abstract class LayoutBaseRepository{

  // TODO: USER
  Future<Either<Failure, UserEntity>> getMyData();
  Future<Either<Failure,Unit>> uploadReport({required String senderID,required String clubName,required String pdfLink,required String clubID,required String reportType});
  Future<bool> updateMyData({required String name,required String college,required String gender,required int phone});
  Future<Either<Failure,Unit>> logout({required EventsCubit eventsCubit,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,});


  Future<Either<Failure,List<NotificationEntity>>> getNotifications();
  Future<Either<Failure,List<UserEntity>>> getAllUsersOnApp();
  Future<Either<Failure,Unit>> sendNotification({required String notifyTitle,required bool toSpecificUserOrNumOfUsers,String? topicName,String? receiverFirebaseToken,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType});

  // TODO: Upload Image to Storage
  Future<Either<Failure,String>> uploadFileToStorage({required File file});

}