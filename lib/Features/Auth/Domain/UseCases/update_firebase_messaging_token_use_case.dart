import 'package:bader_user_app/Features/Auth/Domain/Repositories/auth_contract_repo.dart';

class UpdateMyFirebaseMessagingTokenUseCase {
  final AuthBaseRepository authBaseRepository;

  UpdateMyFirebaseMessagingTokenUseCase({required this.authBaseRepository});

  Future<bool> execute({required String userID}) async {
    return await authBaseRepository.updateMyFirebaseMessagingToken(userID: userID);
  }

}