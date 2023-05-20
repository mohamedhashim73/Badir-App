import 'package:bader_user_app/Core/Errors/failure.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Repositories/layout_contract_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../Core/Constants/enumeration.dart';

class UploadReportToAdminUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  UploadReportToAdminUseCase({required this.layoutBaseRepository});

  Future<Either<Failure,Unit>> execute({required String clubName,required String pdfLink,required String senderID,required String clubID,required String reportType}) async {
    return await layoutBaseRepository.uploadReport(clubName:clubName,senderID:senderID,pdfLink: pdfLink, clubID: clubID, reportType: reportType);
  }

}