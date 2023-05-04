import 'package:bader_user_app/Features/Auth/Domain/Repositories/auth_contract_repo.dart';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUseCase {
  final AuthBaseRepository authBaseRepository;

  LoginUseCase({required this.authBaseRepository});

  Future<Either<Failure,UserCredential>> execute({required String email,required String password}) async {
    try {
      UserCredential userCredential = await authBaseRepository.login(
          email: email, password: password);
      return Right(userCredential);
    }
    on FirebaseAuthException catch (exception) {
      return Left(ServerFailure(errorMessage: exception.code));
    }
  }
}