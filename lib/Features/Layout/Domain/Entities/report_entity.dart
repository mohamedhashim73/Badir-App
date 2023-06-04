import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable{
  final String reportID;
  final String reportType;
  final String clubID;
  final String clubName;
  final String senderID;
  final String pdfLink;
  final bool? isAccepted;

  const ReportEntity({required this.reportID, required this.reportType,required this.clubID,required this.clubName,required this.senderID,required this.pdfLink,required this.isAccepted});

  @override
  // TODO: implement props
  List<Object?> get props => [reportID,reportType,clubID,clubName,senderID,pdfLink,isAccepted];
}