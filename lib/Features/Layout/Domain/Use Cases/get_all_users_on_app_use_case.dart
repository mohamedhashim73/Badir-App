import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../Presentation/Controller/layout_cubit.dart';

class GetAllUsersOnAppUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  GetAllUsersOnAppUseCase({required this.layoutBaseRepository});

  Future<Either<Failure,List<UserEntity>>> execute() async {
    return await layoutBaseRepository.getAllUsersOnApp();
  }

}