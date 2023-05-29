import 'dart:io';

import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Data/Data_Source/layout_data_source.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/notification_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Events/Domain/Entities/event_entity.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../Presentation/Controller/layout_cubit.dart';

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
  Future<Either<Failure,Unit>> uploadReport({required String pdfLink,required String clubName,required String clubID,required String senderID,required String reportType}) async {
    try
    {
      return Right(await layoutRemoteDataSource.uploadReport(senderID: senderID,pdfLink: pdfLink, clubName:clubName,clubID: clubID, reportType: reportType));
    }
    on ServerException catch(e)
    {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }
  @override
  Future<Either<Failure,List<UserEntity>>> getAllUsersOnApp() async {
    try
    {
      return Right(await layoutRemoteDataSource.getAllUsersOnApp());
    }
    on ServerException catch(e)
    {
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> logout({required EventsCubit eventsCubit,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,}) async {
    try
    {
      return Right(await layoutRemoteDataSource.logout(eventsCubit: eventsCubit, clubsCubit: clubsCubit, layoutCubit: layoutCubit));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure,Unit>> sendNotification({required String notifyTitle,required bool toSpecificUserOrNumOfUsers,String? topicName,String? receiverFirebaseToken,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    try
    {
      await layoutRemoteDataSource.sendNotification(receiverFirebaseToken:receiverFirebaseToken,notifyTitle: notifyTitle,toSpecificUserOrNumOfUsers: toSpecificUserOrNumOfUsers,topicName: topicName,receiverID: receiverID, clubID: clubID, notifyContent: notifyContent, notifyType: notifyType);
      return const Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

  // TODO: Will return Image Url
  @override
  Future<Either<Failure,String>> uploadFileToStorage({required File file}) async {
    try
    {
      return Right(await layoutRemoteDataSource.uploadImageToStorage(imgFile: file));
    }
    on ServerException catch(e){
      return Left(ServerFailure(errorMessage: e.exceptionMessage));
    }
  }

}