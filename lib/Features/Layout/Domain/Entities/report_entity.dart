import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable{
  final String reportID;
  final String fileType;
  final String clubID;
  final String pdfLink;

  const ReportEntity({required this.reportID, required this.fileType,required this.clubID,required this.pdfLink});

  @override
  // TODO: implement props
  List<Object?> get props => [reportID,fileType,clubID,pdfLink];
}