import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/Layout_Cubit/layout_states.dart';
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
      'routeName' : 'view_Events'
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
  ];

  DrawerItem({super.key});
  @override
  Widget build(BuildContext context){
    LayoutCubit cubit = LayoutCubit.getInstance(context);
    ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    if( cubit.userData == null ) cubit.getMyData();
    if( clubsCubit.dataAboutClubYouLead == null && cubit.userData!.clubIDThatHeLead!.isNotEmpty ) clubsCubit.getInfoForClubThatILead(clubID: cubit.userData!.clubIDThatHeLead!);
    return Drawer(
        child: BlocBuilder<LayoutCubit,LayoutStates>(
          buildWhen: (last,current) => current is GetMyDataSuccessState ,
          builder: (context,state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                if( cubit.userData != null )
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: AppColors.kMainColor
                    ),
                    accountName: Text(cubit.userData!.name!),
                    accountEmail: Text(cubit.userData!.email!),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,color: Colors.black,),
                    ),
                ),
                if( cubit.userData != null )
                Expanded(
                  child: ListView.builder(
                      itemCount: cubit.userData!.clubIDThatHeLead!.isNotEmpty && cubit.userData!.clubIDThatHeLead != null ? drawerData.length : 3,
                      itemBuilder: (context,index){
                        return ListTile(
                          onTap: ()
                          {
                            Navigator.pushNamed(context, drawerData[index]['routeName']);
                          },
                          leading: Text(drawerData[index]['title']),
                          trailing: Icon(drawerData[index]['iconData']),
                        );
                      }
                  ),
                )
              ],
            );
          }
        )
    );
  }
}