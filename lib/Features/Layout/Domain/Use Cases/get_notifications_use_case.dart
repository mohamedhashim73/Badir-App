import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';
import '../Entities/notification_entity.dart';

class GetNotificationsUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  GetNotificationsUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, List<NotificationEntity>>> execute() async {
    return await layoutBaseRepository.getNotifications();
  }

}