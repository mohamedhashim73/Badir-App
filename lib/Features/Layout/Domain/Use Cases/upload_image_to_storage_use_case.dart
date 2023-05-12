import 'dart:io';
import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';

class UploadImageToStorageUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  UploadImageToStorageUseCase({required this.layoutBaseRepository});

  Future<Either<Failure, String>> execute({required File imgFile}) async {
    return await layoutBaseRepository.uploadFileToStorage(file: imgFile);
  }

}