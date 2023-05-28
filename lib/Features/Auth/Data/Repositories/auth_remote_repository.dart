import 'package:bader_user_app/Features/Auth/Data/Data_Source/auth_data_source.dart';
import 'package:bader_user_app/Features/Auth/Domain/Repositories/auth_contract_repo.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthImplyRepository extends AuthBaseRepository{
  final AuthRemoteDataSource authRemoteDataSource;

  AuthImplyRepository({required this.authRemoteDataSource});

  @override
  Future<UserCredential> login({required String email, required String password}) async {
      return await authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserCredential> register({required String email,required String password}) async {
    return await authRemoteDataSource.register(email: email, password: password);
  }

  @override
  Future<bool> sendUserDataToFirestore({required UserModel user,required String userID}) async {
    try
    {
      await authRemoteDataSource.saveUserDataOnFirestore(user: user, userID: userID);
      return true;
    }
    on FirebaseException catch(exception){
      return false;
    }
  }

  @override
  Future<bool> updateMyFirebaseMessagingToken({required String userID}) async {
    try
    {
      await authRemoteDataSource.updateMyFirebaseMessagingToken(userID: userID);
      return true;
    }
    catch(exception){
      return false;
    }
  }

}