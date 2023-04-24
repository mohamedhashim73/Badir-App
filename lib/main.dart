import 'package:bader_user_app/Auth/Presentation/Controller/auth_cubit.dart';
import 'package:bader_user_app/Auth/Presentation/Screens/login_screen.dart';
import 'package:bader_user_app/Auth/Presentation/Screens/register_screen.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Network/sharedPref.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Core/Utils/service_locators.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Clubs_Cubit/clubs_cubit.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Events_Cubit/events_cubit.dart';
import 'package:bader_user_app/Layout/Presentation/Screens/layout_screen.dart';
import 'package:bader_user_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Core/Constants/bloc_oberver.dart';
import 'Core/Theme/app_colors.dart';
import 'Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocators.serviceLocatorInitialization();    // TODO: GetIT ( Initialize for Objects from Classes )
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  await SharedPref.cacheInitialization();
  Constants.userID = SharedPref.getString(key: 'userID');
  debugPrint("User ID is : ${Constants.userID}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child) {
        return MultiBlocProvider(
          providers:
          [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => ClubsCubit()..getClubsData()),
            BlocProvider(create: (context) => EventsCubit()),
            BlocProvider(create: (context) => LayoutCubit()..getMyData()),
          ],
          child: MaterialApp(
            routes:
            {
              AppStrings.kLoginScreen : (context) => LoginScreen(),
              AppStrings.kRegisterScreen : (context) => RegisterScreen(),
              AppStrings.kLayoutScreen : (context) => const LayoutScreen(),
            },
            theme: ThemeData(
              fontFamily: 'Cairo',
              buttonTheme: ButtonThemeData(
                buttonColor: AppColors.kMainColor
              )
            ),
            debugShowCheckedModeBanner: false,
            home: Constants.userID != null ? const LayoutScreen() : LoginScreen()
          ),
        );
      }
    );
  }
}
