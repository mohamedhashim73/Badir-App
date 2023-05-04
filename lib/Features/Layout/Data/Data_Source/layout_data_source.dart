import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/notification_model.dart';

class LayoutRemoteDataSource {

  // TODO: USER
  Future<UserModel> getMyData() async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(Constants.userID).get();
    return UserModel.fromJson(json: querySnapshot.data());
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

}