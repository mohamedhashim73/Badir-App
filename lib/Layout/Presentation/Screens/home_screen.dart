import 'package:bader_user_app/Layout/Presentation/Controller/Clubs_Cubit/clubs_cubit.dart';
import 'package:flutter/material.dart';

import '../../../Core/Constants/constants.dart';
import '../../../Core/Theme/app_colors.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("الرئيسية")
          ),
          body: const Center(
            child: Text("Main Screen"),
          ),
        ),
      ),
    );
  }
}
