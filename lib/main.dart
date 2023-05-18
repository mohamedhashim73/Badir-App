import 'package:bader_user_app/Core/Constants/app_routes.dart';
import 'package:bader_user_app/Features/Auth/Presentation/Screens/login_screen.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Network/sharedPref.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/send_opinion_about_event_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/layout_screen.dart';
import 'package:bader_user_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Core/Constants/bloc_oberver.dart';
import 'Core/Theme/app_colors.dart';

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
      builder: (context,child){
        return MultiBlocProvider(
          providers: Constants.providers,
          child: BlocBuilder<LayoutCubit,LayoutStates>(
            buildWhen: (pastState,currentState) => currentState is GetMyDataSuccessState,
            builder: (context,state) {
              return MaterialApp(
                routes: AppRoutes.routes,
                theme: ThemeData(
                  fontFamily: 'Cairo',
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.kMainColor,
                    elevation: 0,
                  ),
                  buttonTheme: ButtonThemeData(
                    buttonColor: AppColors.kMainColor
                  )
                ),
                debugShowCheckedModeBanner: false,
                home: Constants.userID != null ? const LayoutScreen() : LoginScreen()
              );
            }
          ),
        );
      }
    );
  }
}
