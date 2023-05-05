import 'dart:io';

import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Features/Clubs/Data/Models/member_model.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../../../Core/Constants/constants.dart';
import '../Models/club_model.dart';
import '../Models/request_membership_model.dart';

class RemoteClubsDataSource{

  Future<String> uploadClubImageToStorage({required File imgFile}) async {
    try{
      Reference imageRef = FirebaseStorage.instance.ref(basename(imgFile.path));
      await imageRef.putFile(imgFile);
      return imageRef.getDownloadURL();
    }
    catch(e){
      throw NoNetworkException(exceptionMessage: "Something went wrong, try again later");
    }
  }

  // TODO: Get Clubs from Firestore
  Future<List<ClubEntity>> getAllClubs() async {
    List<ClubEntity> clubs = [];
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).get();
      for( var item in querySnapshot.docs )
      {
        clubs.add(ClubModel.fromJson(json: item.data()));
      }
      return clubs;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  // TODO: ASK FOR MEMBERSHIP
  Future<bool> requestAMembershipOnSpecificClub({required String clubID,required String requestUserName,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName}) async {
    try{
      final model = RequestMembershipModel(userAskForMembershipID, infoAboutAsker,committeeName,requestUserName);
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembershipRequestsCollectionName).doc(userAskForMembershipID).set(model.toJson());
      return true;
    }
    on FirebaseException catch(e)
    {
      return false;
    }
  }

  Future<Unit> updateClubData({required String clubID, required String image, required String name, required int memberNum, required String aboutClub, required ContactMeansForClubModel contactInfo}) async {
    try{
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
        'name' : name,
        'description' : aboutClub,
        'image' : image,
        'memberNum' : memberNum,
        'contactAccounts' : contactInfo.toJson(),
      });
      return Future.value(unit);
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<void> acceptOrRejectMembershipRequest({required String requestSenderID,required String clubID,required bool respondStatus}) async {
    try
    {
      // ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembershipRequestsCollectionName).doc(requestSenderID).delete();
      if( respondStatus )
        {
          MemberModel member = MemberModel(memberID: requestSenderID, membershipDate: Constants.getTimeNow());
          // هخزن الداتا بتاعه المستخدم ده ك عضو في الكولكشن بتاع النادي
          await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembersDataCollectionName).doc(requestSenderID).set(member.toJson());
        }
      // TODO: I have to send notification to him .....
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<List<RequestMembershipModel>> getMembershipRequests({required String clubID}) async {
    try
    {
      List<RequestMembershipModel> requests = [];
      // ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembershipRequestsCollectionName).get().then((value){
        for( var item in value.docs )
          {
            requests.add(RequestMembershipModel.fromJson(json: item.data()));
          }
      });
      return requests;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

}