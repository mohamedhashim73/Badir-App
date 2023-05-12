import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerItem extends StatelessWidget{
  final List<Map<String,dynamic>> drawerData = [
    {
      'title' : 'الملف الشخصي',
      'iconData' : Icons.person,
      'routeName' : AppStrings.kProfileScreen
    },
    {
      'title' : 'الفعاليات',
      'iconData' : Icons.event_available_sharp,
      'routeName' : AppStrings.kViewEventsScreen
    },
    {
      'title' : 'الأندية',
      'iconData' : Icons.view_agenda,
      'routeName' : AppStrings.kViewClubsScreen
    },
    {
      'title' : 'طلبات العضوية',
      'iconData' : Icons.request_page,
      'routeName' : AppStrings.kMembershipRequestsScreen
    },
    {
      'title' : 'تحديث بيانات النادي',
      'iconData' : Icons.update,
      'routeName' : AppStrings.kUpdateClubScreen
    },
    {
      'title' : 'رفع التقارير',
      'iconData' : Icons.report,
      'routeName' : AppStrings.kUploadReportScreen
    },
    {
      'title' : 'إداره الأعضاء',
      'iconData' : Icons.people,
      'routeName' : AppStrings.kViewMembersOnMyClubScreen
    },
    {
      'title' : 'إدارة الفعاليات',
      'iconData' : Icons.manage_accounts,
      'routeName' : AppStrings.kManageEventsScreen
    },
    {
      'title' : 'إدارة الإجتماعات',
      'iconData' : Icons.meeting_room_sharp,
      'routeName' : AppStrings.kManageMeetingsScreen
    },
    {
      'title' : 'تسجيل الخروج',
      'iconData' : Icons.logout,
      'routeName' : AppStrings.kLoginScreen
    },
  ];

  DrawerItem({super.key});
  @override
  Widget build(BuildContext context){
    LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    EventsCubit eventsCubit  = EventsCubit.getInstance(context);
    if( layoutCubit.userData == null ) layoutCubit.getMyData();
    if( layoutCubit.userData!.idForClubLead != null ) clubsCubit.getCLubDataThatILead(clubID: layoutCubit.userData!.idForClubLead!);
    return Drawer(
        child: BlocBuilder<LayoutCubit,LayoutStates>(
          buildWhen: (last,current) => current is GetMyDataSuccessState ,
          builder: (context,state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                if( layoutCubit.userData != null )
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: AppColors.kMainColor
                    ),
                    accountName: Text(layoutCubit.userData!.name!),
                    accountEmail: Text(layoutCubit.userData!.email!),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,color: Colors.black,),
                    ),
                ),
                if( layoutCubit.userData != null )
                Expanded(
                  child: Column(
                    children:
                    [
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            // TODO: make length-1 as i display last item ( log out ) on the bottom of Drawer
                            itemCount: layoutCubit.userData!.idForClubLead != null ? drawerData.length-1 : 3,
                            itemBuilder: (context,index){
                              return Card(
                                color: Colors.grey.withOpacity(0.1),
                                child: ListTile(
                                  onTap: ()
                                  {
                                    Navigator.pushNamed(context, drawerData[index]['routeName']);
                                  },
                                  iconColor: AppColors.kMainColor,
                                  textColor: AppColors.kMainColor,
                                  splashColor: AppColors.kRedColor,
                                  leading: Text(drawerData[index]['title']),
                                  trailing: Icon(drawerData[index]['iconData']),
                                ),
                              );
                            }
                        ),
                      ),
                      // TODO: log out will be for all Users ( ordinary - member - leader )
                      ListTile(
                        onTap: ()
                        {
                          // TODO: Call log out method.....
                          layoutCubit.logout(eventsCubit: eventsCubit, clubsCubit: clubsCubit, layoutCubit: layoutCubit);
                        },
                        leading: Text(drawerData.last['title']),
                        trailing: Icon(drawerData.last['iconData']),
                      )
                    ],
                  )
                )
              ],
            );
          }
        )
    );
  }
}