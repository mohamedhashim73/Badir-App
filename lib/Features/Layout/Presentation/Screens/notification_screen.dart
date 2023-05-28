import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Data/Models/notification_model.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/drawer_item.dart';
import '../../../../Core/Theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Domain/Entities/notification_entity.dart';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import '../Widgets/notify_component.dart';

class NotificationsScreen extends StatelessWidget {
  List<NotificationEntity> notifications = [];
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    UserEntity userEntity = layoutCubit.userData!;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: DrawerItem(),
            appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("التنبيهات")
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(Constants.kUsersCollectionName).doc(Constants.userID).collection(Constants.kNotificationsCollectionName).snapshots(),
            builder: (context,snapshots){
              if( snapshots.hasData && snapshots.data != null && snapshots.data!.docs.isNotEmpty)
                {
                  notifications.clear();
                  for( var item in snapshots.data!.docs )
                    {
                      if( item.data()['notifyType'].toString().trim() == NotificationType.adminMakesYouALeaderOnSpecificClub.name.trim() && userEntity.idForClubLead == null )
                        {
                          layoutCubit.getMyData(clubsCubit: clubsCubit);
                        }
                      notifications.add(NotifyModel.fromJson(json: item.data()));
                    }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 8.w),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          return NotifyComponent(notifyData: notifications[index]);
                        },
                        separatorBuilder: (context,index){
                          return SizedBox(height: 10.h,);
                        },
                        itemCount: notifications.length
                    ),
                  );
                }
              else if( snapshots.connectionState == ConnectionState.waiting )
                {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                }
              else
                {
                  return Center(
                    child: Text("لا توجد اشعارات حتي الآن",
                      style: TextStyle(
                          color: Colors.grey,fontSize: 15.sp,fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                }
            }
          )
        ),
      ),
    );
  }
}
