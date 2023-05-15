import 'dart:io';

import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/report_model.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../Models/notification_model.dart';

class LayoutRemoteDataSource {

  // TODO: USER
  Future<UserModel> getMyData() async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(Constants.userID).get();
    userModel = UserModel.fromJson(json: documentSnapshot.data());
    return userModel;
  }

  Future<bool> updateMyData({required String name,required String college,required String gender,required int phone}) async {
    try{
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName)
          .doc(Constants.userID).update({
        'name' : name,
        'college' : college,
        'phone' : phone,
        'gender' : gender,
      });
      return true;
    }
    on FirebaseException catch(e){
      return false;
    }
  }

  // TODO: Notifications
  Future<List<NotifyModel>> getNotifications() async {
    List<NotifyModel> notifications = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(Constants.userID).collection(Constants.kNotificationsCollectionName).get();
    for( var item in querySnapshot.docs )
      {
        notifications.add(NotifyModel.fromJson(json: item.data()));
      }
    return notifications;
  }

  Future<void> sendNotification({required String senderID,required String receiverID,required String clubID,required String notifyContent,required NotificationType notifyType}) async {
    try
    {
      NotifyModel notifyModel = NotifyModel(Constants.getTimeNow(), senderID, notifyType.name, false, notifyContent,clubID);
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(receiverID).
      collection(Constants.kNotificationsCollectionName).add(notifyModel.toJson());
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> logout({required EventsCubit eventsCubit,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,}) async {
    try
    {
      await FirebaseAuth.instance.signOut();
      layoutCubit.userData = null;
      layoutCubit.notifications.clear();
      clubsCubit.dataAboutClubYouLead = null;
      eventsCubit.ownEvents.clear();
      layoutCubit.bottomNavIndex = 0;   // TODO: عشان اما يجي يعمل تسجيل دخول يدخل علي ال Home مش Profile لان اخر قيمه له هي 2
      return unit;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<String> uploadImageToStorage({required File imgFile}) async {
    try
    {
      Reference imageRef = FirebaseStorage.instance.ref(basename(imgFile.path));
      await imageRef.putFile(imgFile);
      return await imageRef.getDownloadURL();
    }
    catch(e)
    {
      throw ServerException(exceptionMessage: e.toString());
    }
  }

  Future<List<UserModel>> getAllUsersOnApp() async {
    List<UserModel> users = [];
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).get().then((value){
        for( var item in  value.docs )
          {
            users.add(UserModel.fromJson(json: item.data()));
          }
      });
      return users;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.toString());
    }
  }

  Future<Unit> uploadReport({required String pdfLink,required String clubID,required String reportType}) async {
    try
    {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kReportsCollectionName).get();
      int newReportID = querySnapshot.docs.isNotEmpty ? int.parse(querySnapshot.docs.last.id) : 0;
      ++newReportID;
      ReportModel report = ReportModel(reportID: newReportID.toString(), fileType: reportType, clubID: clubID, pdfLink: pdfLink);
      await FirebaseFirestore.instance.collection(Constants.kReportsCollectionName).doc(newReportID.toString()).set(report.toJson());
      return unit;
    }
    on FirebaseException catch(e)
    {
      throw ServerException(exceptionMessage: e.toString());
    }
  }

}