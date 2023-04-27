abstract class ClubsStates{}

class ClubsInitialState extends ClubsStates{}

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
