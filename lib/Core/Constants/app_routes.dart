import 'package:bader_user_app/Features/Clubs/Presentation/Screens/meetings_management.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Screens/update_club_availablility_screen.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Screens/update_club_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/create_event_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/tasks_management.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/profile_screen.dart';

import '../../Features/Auth/Presentation/Screens/login_screen.dart';
import '../../Features/Auth/Presentation/Screens/register_screen.dart';
import '../../Features/Clubs/Presentation/Screens/create_meeting_screen.dart';
import '../../Features/Clubs/Presentation/Screens/display_membership_requests.dart';
import '../../Features/Clubs/Presentation/Screens/meetings_for_clubs_member_in_screen.dart';
import '../../Features/Clubs/Presentation/Screens/view_clubs.dart';
import '../../Features/Clubs/Presentation/Screens/view_memebrs_on_my_club_screen.dart';
import '../../Features/Events/Presentation/Screens/create_task_screen.dart';
import '../../Features/Events/Presentation/Screens/events_management.dart';
import '../../Features/Events/Presentation/Screens/view_available_tasks_for_member_or_ordinary_user_screen.dart';
import '../../Features/Events/Presentation/Screens/view_events_screen.dart';
import '../../Features/Layout/Presentation/Screens/edit_profile_screen.dart';
import '../../Features/Layout/Presentation/Screens/home_screen.dart';
import '../../Features/Layout/Presentation/Screens/layout_screen.dart';
import '../../Features/Layout/Presentation/Screens/upload_report_to_admin_screen.dart';
import 'app_strings.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static Map<String, Widget Function(BuildContext)> routes = {
    AppStrings.kLoginScreen : (context) => LoginScreen(),
    AppStrings.kViewClubsScreen : (context) => ViewClubsScreen(),
    AppStrings.kHomeScreen : (context) => HomeScreen(),
    AppStrings.kClubAvailabilityScreen : (context) => const UpdateClubAvailabilityScreen(),
    AppStrings.kViewAvailableTasksScreen : (context) => const ViewAvailableTasksScreen(),
    AppStrings.kCreateMeetingScreen : (context) => CreateMeetingScreen(),
    AppStrings.kManageMeetingsScreen : (context) => const MeetingsManagementScreen(),
    AppStrings.kManagementTasksScreen : (context) => const TasksManagementScreen(),
    AppStrings.kViewMeetingsForClubsMemberInScreen : (context) => const MeetingsForClubsMemberInScreen(),
    AppStrings.kUploadReportScreen : (context) => const UploadReportToAdminScreen(),
    AppStrings.kViewMembersOnMyClubScreen : (context) => const ViewMembersOnMyClubScreen(),
    AppStrings.kViewEventsScreen : (context) => const ViewAllEventsThrowAppScreen(),
    AppStrings.kEditProfileScreen : (context) => EditProfileScreen(),
    AppStrings.kRegisterScreen : (context) => RegisterScreen(),
    AppStrings.kLayoutScreen : (context) => const LayoutScreen(),
    AppStrings.kCreateTaskScreen : (context) => CreateTaskScreen(),
    AppStrings.kProfileScreen : (context) => const ProfileScreen(),
    AppStrings.kUpdateClubScreen : (context) => UpdateClubScreen(),
    AppStrings.kCreateEventScreen : (context) => CreateEventScreen(),
    AppStrings.kManageEventsScreen : (context) => const EventsManagementScreen(),
    AppStrings.kPastAndNewEventsScreen : (context) => const ViewAllEventsThrowAppScreen(),
    AppStrings.kMembershipRequestsScreen : (context) => const MembershipRequestsScreen(),
  };
}