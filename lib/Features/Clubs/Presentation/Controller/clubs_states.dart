import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';

abstract class ClubsStates{}

class ClubsInitialState extends ClubsStates{}
class AddOrRemoveOptionToSelectedCollegesState extends ClubsStates{}
class ChangeClubAvailabilityStatusState extends ClubsStates{}

class RemoveMemberFromClubSuccessState extends ClubsStates{}
class RemoveMemberFromClubLoadingState extends ClubsStates{}
class RemoveMemberFromClubWithFailureState extends ClubsStates{
  final String message;
  RemoveMemberFromClubWithFailureState({required this.message});
}

class GetMembershipRequestLoadingState extends ClubsStates{}
class AcceptOrRejectMembershipRequestSuccessState extends ClubsStates{}
class AcceptOrRejectMembershipRequestLoadingState extends ClubsStates{}
class FailedToAcceptOrRejectMembershipRequestState extends ClubsStates{
  final String message;
  FailedToAcceptOrRejectMembershipRequestState({required this.message});
}
class GetMembershipRequestSuccessState extends ClubsStates{}
class FailedToGetMembershipRequestsState extends ClubsStates{
  final String message;
  FailedToGetMembershipRequestsState({required this.message});
}
class ClubUpdatedSuccessState extends ClubsStates{}
class UpdateClubLoadingState extends ClubsStates{}
class FailedToUpdateClubState extends ClubsStates{
  final String message;
  FailedToUpdateClubState({required this.message});
}
class GetIDForClubsIAskedForMembershipSuccessState extends ClubsStates{}
class FailedToGetIDForClubsIAskedForMembershipState extends ClubsStates{
  final String message;
  FailedToGetIDForClubsIAskedForMembershipState({required this.message});
}

class GetInfoForClubThatILeadSuccess extends ClubsStates{}
class ClubImageUploadedSuccess extends ClubsStates{}
class FailedToClubImage extends ClubsStates{}
class ChooseClubImageSuccess extends ClubsStates{}
class ChooseClubImageFailure extends ClubsStates{}

class ChangeSearchAboutClubStatus extends ClubsStates{}
class GetFilteredClubsSuccessState extends ClubsStates{}

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

class UpdateClubAvailabilityLoadingState extends ClubsStates{}
class UpdateClubAvailabilitySuccessState extends ClubsStates{}
class UpdateClubAvailabilityWithFailureState extends ClubsStates{
  final String message;
  UpdateClubAvailabilityWithFailureState({required this.message});
}

class CreateMeetingLoadingState extends ClubsStates{}
class CreateMeetingSuccessState extends ClubsStates{}
class CreateMeetingWithFailureState extends ClubsStates{
  final String message;
  CreateMeetingWithFailureState({required this.message});
}

class GetMemberDataLoadingState extends ClubsStates{}
class GetMemberDataSuccessState extends ClubsStates{
  final UserEntity userEntity;
  GetMemberDataSuccessState({required this.userEntity});
}
class GetMemberDataWithFailureState extends ClubsStates{
  final String message;
  GetMemberDataWithFailureState({required this.message});
}

class GetMeetingRelatedToClubIMemberInLoadingState extends ClubsStates{}
class GetMeetingRelatedToClubIMemberInSuccessState extends ClubsStates{
  final List<MeetingEntity> meetings;
  GetMeetingRelatedToClubIMemberInSuccessState({required this.meetings});
}
class GetMeetingRelatedToClubIMemberInWithFailureState extends ClubsStates{
  final String message;
  GetMeetingRelatedToClubIMemberInWithFailureState({required this.message});
}

class DeleteMeetingLoadingState extends ClubsStates{}
class DeleteMeetingSuccessState extends ClubsStates{}
class DeleteMeetingWithFailureState extends ClubsStates{
  final String message;
  DeleteMeetingWithFailureState({required this.message});
}

class GetMeetingCreatedByLoadingState extends ClubsStates{}
class GetMeetingCreatedBySuccessState extends ClubsStates{}
class GetMeetingCreatedByWithFailureState extends ClubsStates{
  final String message;
  GetMeetingCreatedByWithFailureState({required this.message});
}

class GetMembersOnMyClubDataLoadingState extends ClubsStates{}
class GetMembersOnMyClubDataSuccessState extends ClubsStates{}
class GetMembersOnMyClubDataWithFailureState extends ClubsStates{
  final String message;
  GetMembersOnMyClubDataWithFailureState({required this.message});
}
