import 'dart:async';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/home_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Screens/layout_screen.dart';
import 'package:bader_user_app/Core/Constants/app_routes.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Network/sharedPref.dart';
import 'package:bader_user_app/Core/Service%20Locators/service_locators.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:bader_user_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Core/Components/snackBar_item.dart';
import 'Core/Constants/bloc_oberver.dart';
import 'Core/Theme/app_colors.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("Message while App is closed, message's data is : ${message.data}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await ServiceLocators.serviceLocatorInitialization();    // TODO: GetIT ( Initialize for Objects from Classes )
  Bloc.observer = MyBlocObserver();
  await SharedPref.cacheInitialization();
  Constants.userID = SharedPref.getString(key: 'userID');
  debugPrint("User ID is : ${Constants.userID}");
  // Todo: Receive message on Background as app is closed
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  if( await Constants.isPhysicalDevice() ) debugPrint("Firebase Messaging token is : ${await FirebaseMessaging.instance.getToken()}");
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Todo: Get message while app is open but user outside The Application
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Message while app is opened .....");
      showToastMessage(message: "لديك إشعار جديد",context: context);
      if( message.data['type'] == NotificationType.adminMakesYouALeaderOnSpecificClub.name || message.data['type'] == NotificationType.membershipRemoveFromSpecificClub.name ||message.data['type'] == NotificationType.acceptYourMembershipRequest.name || message.data['type'] == NotificationType.deleteClubForEver.name   )
      {
        Phoenix.rebirth(context);
      }
    });

    // Todo: Get message while app is open but user outside The Application
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      showToastMessage(message: "لديك إشعار جديد",context: context);
      if( message.data['type'] == NotificationType.adminMakesYouALeaderOnSpecificClub.name || message.data['type'] == NotificationType.membershipRemoveFromSpecificClub.name ||message.data['type'] == NotificationType.acceptYourMembershipRequest || message.data['type'] == NotificationType.deleteClubForEver.name   )
      {
        Phoenix.rebirth(context);
      }
    });

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
                home: Constants.userID != null ? LayoutScreen() : HomeScreen()
              );
            }
          ),
        );
      }
    );
  }
}
