import 'package:bader_user_app/Layout/Presentation/Components/notification_components/notify_component.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Layout_Cubit/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutCubit cubit = LayoutCubit.getInstance(context)..getNotifications();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<LayoutCubit,LayoutStates>(
          buildWhen: (previous,currentStat)
          {
            return currentStat is GetNotificationsSuccessState || currentStat is FailedToGetNotificationsState ;
          },
          listener: (context,state){},
          builder: (context,state) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: AppColors.kMainColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
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
