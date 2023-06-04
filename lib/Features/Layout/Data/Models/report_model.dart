import '../../Domain/Entities/report_entity.dart';

class ReportModel extends ReportEntity{
  // Todo: Extend From Achievement Entity

  const ReportModel({
    required super.reportID,
    required super.reportType,
    required super.clubID,
    required super.clubName,
    required super.senderID,
    required super.pdfLink,
    required super.isAccepted,
  });

  // Todo: From JSON to Refactor Data That come from Firestore
  factory ReportModel.fromJson({required Map<String,dynamic> json})
  {
    return ReportModel(
        reportID: json['reportID'],
        reportType:json['reportType'],
        clubID:json['clubID'],
        clubName:json['clubName'],
        senderID:json['senderID'],
        pdfLink:json['pdfLink'],
        isAccepted:json['isAccepted'],
    );
  }

  // Todo: Send Data to Firebase
  Map<String,dynamic> toJson(){
    return {
      'reportID' : reportID,
      'reportType' : reportType,
      'clubID' : clubID,
      'clubName' : clubName,
      'senderID' : senderID,
      'pdfLink' : pdfLink,
      'isAccepted' : super.isAccepted,
    };
  }
}