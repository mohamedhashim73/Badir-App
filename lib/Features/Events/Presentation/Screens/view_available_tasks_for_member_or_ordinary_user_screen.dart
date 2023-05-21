import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
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
import 'package:bader_user_app/Features/Events/Presentation/Screens/view_task_details_screen.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';

class ViewAvailableTasksScreen extends StatelessWidget {
  const ViewAvailableTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserEntity userEntity = LayoutCubit.getInstance(context).userData!;
    final EventsCubit eventCubit = EventsCubit.getInstance(context)..getAvailableTasks(myData: userEntity);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("المهام المتاحة"),),
          body: BlocConsumer<EventsCubit,EventsStates>(
            buildWhen: (pastState,currentState) => currentState is GetAvailableTasksSuccessState || currentState is GetIDForTasksIAskedToAuthenticateSuccessState ,
            listener: (context,state)
            {
              if( state is RequestAuthenticateOnATaskSuccessState )
                {
                  showSnackBar(context: context, message: "تم إرسال الطلب لليدر");
                }
              if( state is FailedToRequestAuthenticateOnATaskState ) showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
                child: eventCubit.availableTasks.isNotEmpty && (state is GetAvailableTasksSuccessState || state is GetIDForTasksIAskedToAuthenticateSuccessState) ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: eventCubit.availableTasks.length,   // TODO: Events Related to Club I lead
                    separatorBuilder: (context,index) => SizedBox(height: 8.h,),
                    itemBuilder: (context,index) => _taskItem(myData: userEntity,cubit:eventCubit,context: context,taskEntity: eventCubit.availableTasks[index])
                    ) : state is GetAvailableTasksLoadingState ? const Center(
                      child: CircularProgressIndicator(),
                  ) : Center(
                      child: Text("لا توجد مهام متاحة",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                )
              );
            }
          ),
        ),
      ),
    );
  }

  // TODO: Three cases .. login - have logined - there is no place
  Widget _taskItem({required UserEntity myData,required TaskEntity taskEntity,required BuildContext context,required EventsCubit cubit}){
    bool taskAvailableAndHaveNotJoinedYet = ( (myData.idForTasksAuthenticate != null && myData.idForTasksAuthenticate!.contains(taskEntity.id.toString().trim()) == false) || myData.idForTasksAuthenticate == null ) && taskEntity.numOfPosition - taskEntity.numOfRegistered != 0;
    bool taskNotAvailableAndHaveNotJoined = ( (myData.idForTasksAuthenticate != null && myData.idForTasksAuthenticate!.contains(taskEntity.id.toString().trim()) == false) || myData.idForTasksAuthenticate == null ) && taskEntity.numOfPosition - taskEntity.numOfRegistered == 0;
    bool alreadyJoinedToTask = myData.idForTasksAuthenticate != null && myData.idForTasksAuthenticate!.contains(taskEntity.id.toString().trim()) == true;
    bool requestSendAlreadyToAuthenticateToTaskAndWaitingIt = cubit.idForTasksThatIAskedToAuthenticateBefore != null && cubit.idForTasksThatIAskedToAuthenticateBefore!.contains(taskEntity.id.toString());
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTaskDetailsScreen(taskEntity: taskEntity)));
      },
      child: Card(
        elevation: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text("${taskEntity.name} - ${taskEntity.forPublicOrSpecificToAnEvent ? "غير خاصة بفعالية معينه" : "فعالية ${taskEntity.eventName}"}",style: TextStyle(fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 15.sp),),
              SizedBox(height: 15.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                [
                  _buttonItem(
                    title: (taskEntity.numOfPosition - taskEntity.numOfRegistered).toString() ,
                  ),
                  SizedBox(width: 10.w,),
                  _buttonItem(
                      title: "${taskEntity.hours} ساعات",
                      ),
                  SizedBox(width: 10.w,),
                  _buttonItem(
                      color: requestSendAlreadyToAuthenticateToTaskAndWaitingIt ? AppColors.kOrangeColor : alreadyJoinedToTask ? AppColors.kGreenColor : taskAvailableAndHaveNotJoinedYet ? AppColors.kMainColor : AppColors.kRedColor,
                      title: requestSendAlreadyToAuthenticateToTaskAndWaitingIt ? "تم الطلب" : alreadyJoinedToTask ? "تم التسجيل" : taskAvailableAndHaveNotJoinedYet ? "سجل الآن" : "تم الإكتفاء",
                      onTap: ()
                      {
                        if( cubit.idForTasksThatIAskedToAuthenticateBefore != null && cubit.idForTasksThatIAskedToAuthenticateBefore!.contains(taskEntity.id.toString().trim()) )
                        {
                          showSnackBar(context: context, message: 'تم إرسال طلب بالفعل، ف انتظار مصادقة الليدر');
                        }
                        else if ( myData.idForTasksAuthenticate != null && myData.idForTasksAuthenticate!.contains(taskEntity.id.toString().trim()) )
                        {
                          showSnackBar(context: context, message: 'تمت المصادقة من قبل');
                        }
                        else
                        {
                          cubit.requestToAuthenticateOnATask(myData: myData,taskID: taskEntity.id.toString(), senderID: myData.id ?? Constants.userID!, senderName: myData.name!);
                        }
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonItem({required String title,Function()? onTap,Color? color}) {
    return GestureDetector(
      onTap: onTap ?? (){},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: color ?? AppColors.kYellowColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h),
        child: Text(title,style: TextStyle(color: AppColors.kWhiteColor),),
      ),
    );
  }

}
