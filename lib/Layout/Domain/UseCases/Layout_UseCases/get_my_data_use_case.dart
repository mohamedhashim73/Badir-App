import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';

class GetMyDataUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  GetMyDataUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, UserEntity>> execute() async {
    return await layoutBaseRepository.getMyData();
  }

}