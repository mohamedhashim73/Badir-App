import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Data/Models/request_authentication_on_task_model.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/task_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';

class ViewRequestsForAuthenticateOnTaskScreen extends StatelessWidget {
  final TaskEntity task;
  const ViewRequestsForAuthenticateOnTaskScreen({Key? key,required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    final EventsCubit eventCubit = EventsCubit.getInstance(context)..getRequestForAuthenticateOnATask(taskID: task.id.toString().trim());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("مصادقة المهام"),),
          body: BlocConsumer<EventsCubit,EventsStates>(
            buildWhen: (pastState,currentState) => currentState is GetRequestForAuthenticateOnATaskSuccessState || currentState is FailedToGetRequestForAuthenticateOnATaskState,
            listener: (context,state)
            {
              if( state is AcceptOrRejectAuthenticateRequestOnATaskLoadingState )
                {
                  showLoadingDialog(context:context);
                }
              if( state is AcceptOrRejectAuthenticateRequestOnATaskSuccessState )
                {
                  Navigator.pop(context);
                  showToastMessage(context: context, message: "تم المصادقة بنجاح");
                }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: state is GetRequestForAuthenticateOnATaskLoadingState ? const Center(child: CircularProgressIndicator()) :
                state is GetRequestForAuthenticateOnATaskSuccessState && state.requests.isNotEmpty ?
                ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.requests.length,   // TODO: Events Related to Club I lead
                    separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                    itemBuilder: (context,index) => _requestItem(layoutCubit:layoutCubit,eventsCubit:eventCubit,context: context,requestData: state.requests[index], task: task)
                ) : Center(
                  child: Text("لا توجد طلبات للمصادقة",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  // TODO: Three cases .. login - have logined - there is no place
  Widget _requestItem({required TaskEntity task,required BuildContext context,required EventsCubit eventsCubit,required LayoutCubit layoutCubit,required RequestAuthenticationOnATaskModel requestData}){
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            _textSpan(title: "إسم المهمة", value:task.name),
            _textSpan(title: "إسم الفعالية", value: "${task.forPublicOrSpecificToAnEvent ? "غير خاص بفعالية معينه" : task.eventName}"),
            _textSpan(title: "العضو", value:requestData.senderName),
            _textSpan(title: "عدد الساعات", value:task.hours.toString()),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
              [
                _buttonItem(
                    title: "موافقة",
                    color: AppColors.kGreenColor,
                    onTap: ()
                    {
                      eventsCubit.acceptOrRejectAuthenticateRequestOnATask(myID: layoutCubit.userData!.id ?? Constants.userID!, layoutCubit: layoutCubit, requestSenderName: requestData.senderName,requestFirebaseFCMToken: requestData.senderFirebaseFCMToken, taskEntity: task, requestSenderID: requestData.senderID!, respondStatus: true);
                    }
                ),
                SizedBox(width: 10.w,),
                _buttonItem(
                    title: "إلغاء",
                    color: AppColors.kRedColor,
                    onTap: ()
                    {
                      eventsCubit.acceptOrRejectAuthenticateRequestOnATask(myID: layoutCubit.userData!.id ?? Constants.userID!, layoutCubit: layoutCubit, requestSenderName: requestData.senderName,requestFirebaseFCMToken: requestData.senderFirebaseFCMToken, taskEntity: task, requestSenderID: requestData.senderID, respondStatus: false);
                    }
                    ),
              ],
            ),
          ],
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

  dynamic _textSpan({required String title,required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [
        Text("$title : ",style: TextStyle(color: AppColors.kMainColor,fontSize: 15.sp,fontWeight: FontWeight.bold)),
        Expanded(child: Text(value,style: TextStyle(color: AppColors.kBlackColor,fontSize: 14.sp,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis))),
      ]
    );
  }

}
