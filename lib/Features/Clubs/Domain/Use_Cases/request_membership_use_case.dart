import '../Contract_Repositories/club_contract_repository.dart';

class RequestAMembershipUseCase{
  final ClubsContractRepository clubsContractRepository;

  RequestAMembershipUseCase({required this.clubsContractRepository});

  Future<bool> execute({required String clubID,required String requestUserName,required String userAskForMembershipID,required String infoAboutAsker,required String committeeName}) async {
    return await clubsContractRepository.requestAMembershipOnSpecificClub(clubID: clubID, requestUserName: requestUserName, userAskForMembershipID: userAskForMembershipID, infoAboutAsker: infoAboutAsker, committeeName: committeeName);
  }

}