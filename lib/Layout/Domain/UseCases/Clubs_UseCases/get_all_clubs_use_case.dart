import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Repositories/layout_contract_repo.dart';

class GetAllClubsUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  GetAllClubsUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, List<ClubEntity>>> execute() async {
    return await layoutBaseRepository.getClubs();
  }

}