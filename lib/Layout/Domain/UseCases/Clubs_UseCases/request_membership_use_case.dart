import '../../Repositories/layout_contract_repo.dart';

class RequestAMembershipUseCase{
  final LayoutBaseRepository layoutBaseRepository;

  RequestAMembershipUseCase({required this.layoutBaseRepository});

  Future<bool> execute({required String clubID,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName,required String requestUserName}) async {
    return await layoutBaseRepository.requestAMembershipOnSpecificClub(clubID: clubID,userAskForMembershipID: userAskForMembershipID,infoAboutAsker: infoAboutAsker,committeeName: committeeName,requestUserName: requestUserName);
  }

}