import 'dart:io';

import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/notification_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Events/Domain/Entities/event_entity.dart';

class LayoutImplyRepository implements LayoutBaseRepository {
  final LayoutRemoteDataSource layoutRemoteDataSource;
  LayoutImplyRepository({required this.layoutRemoteDataSource});

  @override
  Future<bool> updateMyData({required String name,required String college,required String gender,required int phone}) {
    return layoutRemoteDataSource.updateMyData(name: name, college: college, gender: gender, phone: phone);
  }


  @override
  Future<Either<Failure,List<NotificationEntity>>> getNotifications() async {
    try
    {
      return Right(await layoutRemoteDataSource.getNotifications());
    }
    on FirebaseException catch(exception){
      return Left(ServerFailure(errorMessage: exception.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMyData() async {
    try
    {
      return Right((await layoutRemoteDataSource.getMyData()));
    }
    on FirebaseException catch(e){
      return Left(ServerFailure(errorMessage: e.code));
    }
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure,Unit>> sendNotification({required String senderID,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    try
    {
      await layoutRemoteDataSource.sendNotification(senderID: senderID, receiverID: receiverID, clubID: clubID, notifyContent: notifyContent, notifyType: notifyType);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  // TODO: Will return Image Url
  @override
  Future<Either<Failure,String>> uploadClubImageToStorage({required File imgFile}) async {
    try
    {
      return Right(await layoutRemoteDataSource.uploadImageToStorage(imgFile: imgFile));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

}