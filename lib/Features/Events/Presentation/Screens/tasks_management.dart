import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/task_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/event_details_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/update_event_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/update_task_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/view_memebrs_on_an_event_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/view_requests_for_authentication_on_task_screen.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/view_task_details_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';

class TasksManagementScreen extends StatelessWidget {
  const TasksManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idForClubILead = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    final eventCubit = EventsCubit.getInstance(context);
    if( eventCubit.tasksCreatedByMe.isEmpty ) eventCubit.getTasksCreatedByMe(idForClubILead: idForClubILead);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("إدارة المهام"),),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, AppStrings.kCreateTaskScreen);
            },
            backgroundColor: AppColors.kMainColor,
            child: const Icon(Icons.add),
          ),
          body: BlocConsumer<EventsCubit,EventsStates>(
            buildWhen: (pastState,currentState) => currentState is GetTasksThatCreatedByMeSuccessState,
            listener: (context,state)
            {
              if( state is DeleteTaskLoadingState )
                {
                  showLoadingDialog(context:context);
                }
              if( state is DeleteTaskSuccessState )
                {
                  Navigator.pop(context);
                  showToastMessage(context: context, message: 'تم حذف المهمة');
                }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: state is GetTasksThatCreatedByMeLoadingState ? const Center(child: CircularProgressIndicator()) : eventCubit.tasksCreatedByMe.isNotEmpty ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: eventCubit.tasksCreatedByMe.length,   // TODO: Events Related to Club I lead
                    separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                    itemBuilder: (context,index) => _taskItem(idForClubILead: idForClubILead,cubit:eventCubit,context: context,taskEntity: eventCubit.tasksCreatedByMe[index])
                ) : Center(
                  child: Text("لا يتم إضافة أي مهمة حتي الآن",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _taskItem({required String idForClubILead,required TaskEntity taskEntity,required BuildContext context,required EventsCubit cubit}){
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTaskDetailsScreen(taskEntity: taskEntity)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
        color: AppColors.kYellowColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskEntity.name,style: TextStyle(fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 15.sp),),
            SizedBox(height: 5.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
              [
                _buttonItem(
                  title: 'تحديث',
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTaskScreen(taskEntity: taskEntity)));
                  },
                ),
                SizedBox(width: 5.w,),
                _buttonItem(
                    title: 'الطلبات',
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRequestsForAuthenticateOnTaskScreen(task: taskEntity)));
                    }
                    ),
                SizedBox(width: 5.w,),
                _buttonItem(
                    title: 'حذف',
                    onTap: ()
                    {
                      cubit.deleteTask(taskID: taskEntity.id.toString(), idForClubILead: idForClubILead);
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonItem({required String title,required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: AppColors.kMainColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h),
        child: Text(title,style: TextStyle(color: AppColors.kWhiteColor),),
      ),
    );
  }

}
