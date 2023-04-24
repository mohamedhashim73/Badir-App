import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import '../../Repositories/layout_contract_repo.dart';

class GetAllEventsUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  GetAllEventsUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, List<EventEntity>>> execute() async {
    return await layoutBaseRepository.getEvents();
  }

}