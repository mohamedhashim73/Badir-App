import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../Presentation/Controller/layout_cubit.dart';

class LogOutUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  LogOutUseCase({required this.layoutBaseRepository});

  Future<Either<Failure,Unit>> execute({required EventsCubit eventsCubit,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,}) async {
    return await layoutBaseRepository.logout(eventsCubit: eventsCubit, clubsCubit: clubsCubit, layoutCubit: layoutCubit);
  }

}