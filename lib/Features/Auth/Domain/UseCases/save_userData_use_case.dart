import 'package:bader_user_app/Features/Auth/Domain/Repositories/auth_contract_repo.dart';
import '../../../Layout/Data/Models/user_model.dart';

class SendUserDataToFirestoreUseCase {
  final AuthBaseRepository authBaseRepository;

  SendUserDataToFirestoreUseCase({required this.authBaseRepository});

  Future<void> execute({required UserModel user,required String userID}) async {
    await authBaseRepository.sendUserDataToFirestore(userID: userID,user: user);
  }

}