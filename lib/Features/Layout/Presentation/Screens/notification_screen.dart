import 'package:bader_user_app/Features/Layout/Presentation/Components/notification_components/notify_component.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/drwaer_item.dart';
import '../../../../Core/Theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutCubit cubit = LayoutCubit.getInstance(context)..getNotifications();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<LayoutCubit,LayoutStates>(
          listener: (context,state){},
          builder: (context,state) {
            return Scaffold(
                drawer: DrawerItem(),
                appBar: AppBar(
                  backgroundColor: AppColors.kMainColor,
                  elevation: 0,
                  title: const Text("التنبيهات")
              ),
              body: cubit.notifications.isNotEmpty ?
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 8.w),
                    child: ListView.separated(
                        itemBuilder: (context,index)
                        {
                          return NotifyComponent(notifyData: cubit.notifications[index]);
                        },
                        separatorBuilder: (context,index){
                          return SizedBox(height: 10.h,);
                        },
                        itemCount: cubit.notifications.length
                    ),
                  ) :
                  Center(
                    child: state is GetNotificationsLoadingState ?
                      const CircularProgressIndicator() :
                      Text(
                        state is FailedToGetNotificationsState ? "حدث خطأ ما ، برجاء التحقق من الإنترنت" : "لا توجد اشعارات حتي الآن",
                        style: TextStyle(
                          color: Colors.grey,fontSize: 15.sp,fontWeight: FontWeight.w500
                        ),
                      ),
                  )
            );
          }
        ),
      ),
    );
  }
}
