import 'package:firebase_auth/firebase_auth.dart';
import '../../../Layout/Data/Models/user_model.dart';

// Todo: Contract Repositories
abstract class AuthBaseRepository{

  Future<UserCredential> register({required String email,required String password});

  Future<UserCredential> login({required String email,required String password});

  Future<bool> sendUserDataToFirestore({required UserModel user,required String userID});

  Future<bool> updateMyFirebaseMessagingToken({required String userID});

}