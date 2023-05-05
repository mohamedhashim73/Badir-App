abstract class ClubsStates{}

class ClubsInitialState extends ClubsStates{}
class ClubUpdatedSuccessState extends ClubsStates{}
class UpdateClubLoadingState extends ClubsStates{}
class FailedToUpdateClubState extends ClubsStates{
  final String message;
  FailedToUpdateClubState({required this.message});
}
class GetInfoForClubThatILeadSuccess extends ClubsStates{}
class ClubImageUploadedSuccess extends ClubsStates{}
class FailedToClubImage extends ClubsStates{}
class ChooseClubImageSuccess extends ClubsStates{}
class ChooseClubImageFailure extends ClubsStates{}

class ChangeSearchAboutClubStatus extends ClubsStates{}
class GetFilteredClubsSuccessStatus extends ClubsStates{}

class CollegeChosenSuccessState extends ClubsStates{}
class CommitteeChosenSuccessState extends ClubsStates{}

class SendRequestForMembershipSuccessState extends ClubsStates{}
class SendRequestForMembershipLoadingState extends ClubsStates{}
class FailedToSendRequestForMembershipState extends ClubsStates{}

class GetClubsLoadingState extends ClubsStates{}
class GetClubsDataSuccessState extends ClubsStates{}
class FailedToGetClubsDataState extends ClubsStates{
  final String message;
  FailedToGetClubsDataState({required this.message});
}
