import 'package:flutter/material.dart';

import '../../../Core/Constants/constants.dart';
import '../../../Core/Theme/app_colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("الملف الشخصي")
          ),
          body: const Center(
            child: Text("Profile"),
          ),
        ),
      ),
    );
  }
}
