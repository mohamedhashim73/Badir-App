import '../../Features/Auth/Presentation/Screens/login_screen.dart';
import '../../Features/Auth/Presentation/Screens/register_screen.dart';
import '../../Features/Clubs/Presentation/Screens/view_clubs.dart';
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
  };
}