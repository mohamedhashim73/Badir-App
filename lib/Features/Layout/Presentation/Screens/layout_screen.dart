import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../Controller/layout_cubit.dart';
import '../Controller/layout_states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.bottomNavIndex,
              selectedItemColor: AppColors.kMainColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: (index)
              {
                cubit.changeBottomNavIndex(index: index);
              },
              items:
              const
              [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "الصفحة الرئيسية"),
                BottomNavigationBarItem(icon: Icon(Icons.notification_important),label: "التنبيهات"),
                BottomNavigationBarItem(icon: Icon(Icons.person),label: "الملف الشخصي"),
              ],
            ),
            body: cubit.layoutScreens[cubit.bottomNavIndex],
          ),
        );
      },
    );
  }
}

