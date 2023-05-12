import '../../Domain/Entities/report_entity.dart';

class ReportModel extends ReportEntity{
  // Todo: Extend From Achievement Entity

  const ReportModel({
    required super.reportID,
    required super.fileType,
    required super.clubID,
    required super.pdfLink,
  });

  // Todo: From JSON to Refactor Data That come from Firestore
  factory ReportModel.fromJson({required Map<String,dynamic> json})
  {
    return ReportModel(
        reportID: json['reportID'],
        fileType:json['fileType'],
        clubID:json['clubID'],
        pdfLink:json['pdfLink'],
    );
  }

  // Todo: Send Data to Firebase
  Map<String,dynamic> toJson(){
    return {
      'reportID' : reportID,
      'fileType' : fileType,
      'clubID' : clubID,
      'pdfLink' : pdfLink,
    };
  }
}