import 'package:bader_user_app/Features/Clubs/Presentation/Screens/update_club_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/create_event_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/profile_screen.dart';

import '../../Features/Auth/Presentation/Screens/login_screen.dart';
import '../../Features/Auth/Presentation/Screens/register_screen.dart';
import '../../Features/Clubs/Presentation/Screens/display_membership_requests.dart';
import '../../Features/Clubs/Presentation/Screens/view_clubs.dart';
import '../../Features/Events/Presentation/Screens/events_management.dart';
import '../../Features/Events/Presentation/Screens/view_events_screen.dart';
import '../../Features/Layout/Presentation/Screens/edit_profile_screen.dart';
import '../../Features/Layout/Presentation/Screens/layout_screen.dart';
import 'app_strings.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static Map<String, Widget Function(BuildContext)> routes = {
    AppStrings.kLoginScreen : (context) => LoginScreen(),
    AppStrings.kViewClubsScreen : (context) => ViewClubsScreen(),
    AppStrings.kEditProfileScreen : (context) => EditProfileScreen(),
    AppStrings.kRegisterScreen : (context) => RegisterScreen(),
    AppStrings.kLayoutScreen : (context) => const LayoutScreen(),
    AppStrings.kProfileScreen : (context) => const ProfileScreen(),
    AppStrings.kUpdateClubScreen : (context) => UpdateClubScreen(),
    AppStrings.kCreateEventScreen : (context) => CreateEventScreen(),
    AppStrings.kManageEventsScreen : (context) => const EventsManagementScreen(),
    AppStrings.kPastAndNewEventsScreen : (context) => const PastAndNewEventsScreen(),
    AppStrings.kMembershipRequestsScreen : (context) => const MembershipRequestsScreen(),
  };
}