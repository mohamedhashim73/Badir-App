import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../Layout/Data/Models/user_model.dart';

// TODO: Responsible for connect | Call Firebase
class AuthRemoteDataSource {

  Future<UserCredential> register({required String email,required String password}) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login({required String email,required String password}) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> saveUserDataOnFirestore({required UserModel user,required String userID}) async {
    await FirebaseFirestore.instance.collection("Users").doc(userID).set(user.toJson());
  }

  Future<void> updateMyFirebaseMessagingToken({required String userID}) async {
    String? firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
    if( firebaseMessagingToken != null )
      {
        await FirebaseFirestore.instance.collection("Users").doc(userID).update({
          'firebaseMessagingToken' : firebaseMessagingToken
        });
      }
  }
}