import 'dart:io';
import 'package:bader_user_app/Core/Errors/exceptions.dart';
import 'package:bader_user_app/Features/Clubs/Data/Models/meeting_model.dart';
import 'package:bader_user_app/Features/Clubs/Data/Models/member_model.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../../../Core/Constants/constants.dart';
import '../Models/club_model.dart';
import '../Models/request_membership_model.dart';

class RemoteClubsDataSource{

  Future<String> uploadClubImageToStorage({required File imgFile}) async {
    try
    {
      Reference imageRef = FirebaseStorage.instance.ref(basename(imgFile.path));
      await imageRef.putFile(imgFile);
      return imageRef.getDownloadURL();
    }
    catch(e){
      throw ServerException(exceptionMessage: "Something went wrong, try again later");
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

  Future<Set<String>> getMembersOnMyClub({required String clubID}) async {
    Set<String> membersID = {};
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembersDataCollectionName).get().then((value){
        for( var item in value.docs )
          {
            membersID.add(item.data()['memberID']);
          }
      });
      return membersID;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  // TODO: ASK FOR MEMBERSHIP
  Future<bool> requestAMembershipOnSpecificClub({required String clubID,required String senderFirebaseFCMToken,required String requestUserName,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName}) async {
    try{
      final model = RequestMembershipModel(userAskForMembershipID, infoAboutAsker,committeeName,requestUserName,senderFirebaseFCMToken);
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

  // TODO: هترجع id بتاع الأندية اللي انا بعت طلب تسجيل فيها بالفعل -- عشان اظهر ان تم ارسال طلب بالفعل
  Future<Set> getIDForClubsIAskedForMembership({List? idForClubsMemberID,required String userID}) async {
    Set clubsID = {};
    await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).get().then((value) async {
      for( var item in value.docs )
      {
        if( (idForClubsMemberID != null && idForClubsMemberID.contains(item.id) == false ) || idForClubsMemberID == null )
        {
          await item.reference.collection(Constants.kMembershipRequestsCollectionName).get().then((value) async {
            for( var itemDoc in value.docs )
            {
              if( itemDoc.id.trim() == userID.trim() ) clubsID.add(item.id);
            }
          });
        }
      }
    });
    debugPrint("Num of Requests send to Clubs is : ${clubsID.length}");
    return clubsID;
  }

  // TODO: ده عشان الاسكرينه بتاع تحديد الكليات اللي مسموح لها بالانضمام للنادي
  Future<Unit> updateClubAvailability({required String clubID,required bool isAvailable,required List availableOnlyForThisCollege}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
        'availableOnlyForThisCollege' : availableOnlyForThisCollege,
        'isAvailable' : isAvailable,
      });
      return Future.value(unit);
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  // TODO: This method will get the number of members | use it when add new member to change its value on Members Number Collection
  Future<int> getMembersNumOnApp() async {
    int membersNum = 0;
    await FirebaseFirestore.instance.collection(Constants.kMembersNumberCollectionName).doc('Number').get().then((value){
      membersNum = value.data() != null  ? value.data()!['total'] : 0;
    });
    return membersNum;
  }

  // TODO: This method will get the number of members | use it when add new member to change its value on Members Number Collection
  Future<int> getNumOfRegisteredMembersOnSpecificClub({required clubID}) async {
    int membersNum = 0;
    await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).get().then((value) async {
      membersNum = value.data() != null ? value.data()!['numOfRegisteredMembers'] ?? 0 : 0;
    });
    return membersNum;
  }

  Future<void> acceptOrRejectMembershipRequest({required String committeeNameForRequestSender,required String requestSenderID,required String clubID,required bool respondStatus}) async {
    try
    {
      // TODO: ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembershipRequestsCollectionName).doc(requestSenderID).delete();
      if( respondStatus )     // TODO: Request Accepted
        {
          // TODO: Update numOfRegisteredMembers that on Club as he become a member
          int numOfRegisteredMembersOnClub = await getNumOfRegisteredMembersOnSpecificClub(clubID: clubID);
          await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
            'numOfRegisteredMembers' : ++numOfRegisteredMembersOnClub
          });
          // TODO: Get Data about RequestSender....
          DocumentSnapshot requestSenderDocumentSnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(requestSenderID).get();
          UserModel requestSenderUserModel = UserModel.fromJson(json: requestSenderDocumentSnapshot.data());
          List? idForClubsThatSenderMemberIn = requestSenderUserModel.idForClubsMemberIn ?? [];
          List? committeesNameForRequestSender = requestSenderUserModel.committeesNames ?? [];
          // TODO: بالنسبه لتاريخ بدء العضوية للشخص ده لو في قيمه مش هعدل عليها لو مفيش هبعت التاريخ الحالي
          String memberShipStartDateForRequestSender = requestSenderUserModel.membershipStartDate ?? Constants.getTimeNow();
          // TODO: في key في الداتا بتاع العضو اسمها idForClubMemberIn محتاج ابعت id بتاع النادي لها بما ان اصبح عضو فيه
          idForClubsThatSenderMemberIn.add(clubID); // TODO: I will update requestSenderData specially the key ( idForClubsMemberIn )
          if( committeesNameForRequestSender.contains(committeeNameForRequestSender) == false ) committeesNameForRequestSender.add(committeeNameForRequestSender); // TODO: I will update requestSenderData specially the key ( idForClubsMemberIn )
          // TODO: هنا مش هضيف اسم اللجنه لو هو بالفعل مثلا عضو في نادي تاني بس منضم لنفس اللجنة
          await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(requestSenderID).update({
            'idForClubsMemberIn' : idForClubsThatSenderMemberIn,
            'committeesNames' : committeesNameForRequestSender,
            'membershipStartDate' : memberShipStartDateForRequestSender
          });
          // TODO: Update Value of Members Number on its Collection as I listen for it on Home Screen
          int membersNum = await getMembersNumOnApp();
          await FirebaseFirestore.instance.collection(Constants.kMembersNumberCollectionName).doc('Number').set({
            'total' : ++membersNum
          });
          MemberModel member = MemberModel(memberName:requestSenderUserModel.name!,memberID: requestSenderID, membershipDate: Constants.getTimeNow());
          // TODO: هخزن الداتا بتاعه المستخدم ده ك عضو في الكولكشن بتاع النادي
          await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembersDataCollectionName).doc(requestSenderID).set(member.toJson());
        }
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

  Future<List<MeetingModel>> getMeetingRelatedToClubIMemberIn({required List idForClubsMemberIn}) async {
    try
    {
      List<MeetingModel> meetings = [];
      // ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).get().then((value) async {
        debugPrint("start getting meetings .......");
        for( var item in value.docs )
        {
          if( idForClubsMemberIn.contains(item.id.trim()) )
            {
              await item.reference.collection(Constants.kMeetingsCollectionName).get().then((val) async {
                for( var meetingDoc in val.docs )
                  {
                    meetings.add(MeetingModel.fromJson(json: meetingDoc.data()));
                  }
              });
            }
        }
      });
      debugPrint("in the end, Meetings num is : ${meetings.length}");
      return meetings;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<List<MeetingModel>> getMeetingCreatedByMe({required String clubID}) async {
    try
    {
      List<MeetingModel> meetings = [];
      // ف كلا الحالتين هحذف م الطلبات
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMeetingsCollectionName).get().then((value){
        for( var item in value.docs )
        {
          meetings.add(MeetingModel.fromJson(json: item.data()));
        }
      });
      return meetings;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<UserModel> getMemberData({required String memberID}) async {
    try
    {
      late UserModel userModel;
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(memberID).get().then((value) async {
        userModel = UserModel.fromJson(json: value.data());
      });
      return userModel;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> createMeeting({required String idForClubILead,required String name,required String description,required String date,required String time,required String location,required String link}) async {
    try
    {
      // TODO: Get Last ID For Last Event to increase it by one
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(idForClubILead).collection(Constants.kMeetingsCollectionName).get();
      int newMeetingID = querySnapshot.docs.isNotEmpty ? int.parse(querySnapshot.docs.last.id) : 0;
      ++newMeetingID;
      MeetingModel meetingModel = MeetingModel(name, newMeetingID.toString(),description, date,time,location, link);
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(idForClubILead).collection(Constants.kMeetingsCollectionName).doc(newMeetingID.toString()).set(meetingModel.toJson());
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

  Future<Unit> deleteMeeting({required String meetingID,required String clubID}) async {
    try
    {
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMeetingsCollectionName).doc(meetingID).delete();
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }


  // TODO: Leader can remove A Member from the Club That he lead .....
  Future<Unit> removeMemberFromClubILead({required String memberID,required String clubID}) async {
    try
    {
      // TODO: Update numOfRegisteredMembers that on Club as he left club
      int numOfRegisteredMembersOnClub = await getNumOfRegisteredMembersOnSpecificClub(clubID: clubID);
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).update({
        'numOfRegisteredMembers' : --numOfRegisteredMembersOnClub
      });
      // TODO: Get Data about RequestSender....
      DocumentSnapshot memberDocumentSnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(memberID).get();
      UserModel memberModel = UserModel.fromJson(json: memberDocumentSnapshot.data());
      List? idForClubsThatHeMemberIn = memberModel.idForClubsMemberIn!;
      await Future.value(idForClubsThatHeMemberIn.remove(clubID));  // TODO: Delete Club ID from This list, will update his date on Firestore)
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(memberID).update({
        'idForClubsMemberIn' : idForClubsThatHeMemberIn.isNotEmpty ? idForClubsThatHeMemberIn : null
      });
      // TODO: Delete his document from Members Data that on the Club
      await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).doc(clubID).collection(Constants.kMembersDataCollectionName).doc(memberID).delete();
      // TODO: reduce the number of members on Member Num collection by 1
      int membersNum = await getMembersNumOnApp();
      await FirebaseFirestore.instance.collection(Constants.kMembersNumberCollectionName).doc('Number').update({
        'total' : --membersNum
      });
      return unit;
    }
    on FirebaseException catch(e){
      throw ServerException(exceptionMessage: e.code);
    }
  }

}