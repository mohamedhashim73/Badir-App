import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';

class UpdateMyDataUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  UpdateMyDataUseCase({required this.layoutBaseRepository});

  Future<bool> execute({required String name,required String college,required String gender,required int phone}) async {
    return await layoutBaseRepository.updateMyData(name: name,college: college,gender: gender,phone: phone);
  }

}