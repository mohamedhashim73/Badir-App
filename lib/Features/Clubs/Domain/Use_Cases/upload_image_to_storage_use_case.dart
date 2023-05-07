import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../Contract_Repositories/club_contract_repository.dart';
import 'dart:io';

class UploadClubImageToStorageUseCase{
  final ClubsContractRepository clubsContractRepository;

  UploadClubImageToStorageUseCase({required this.clubsContractRepository});

  Future<Either<Failure,String>> execute({required File imageFile}) async {
    return await clubsContractRepository.uploadClubImageToStorage(imgFile: imageFile);
  }

}