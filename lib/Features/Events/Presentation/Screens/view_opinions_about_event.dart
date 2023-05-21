import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Events/Data/Models/request_authentication_on_task_model.dart';
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
import '../../Data/Models/opinion_about_event_model.dart';

class ViewOpinionsAboutEventScreen extends StatelessWidget {
  final String eventID;
  const ViewOpinionsAboutEventScreen({Key? key,required this.eventID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventsCubit.getInstance(context).getOpinionsAboutEvent(eventID: eventID);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("الأراء"),),
          body: BlocConsumer<EventsCubit,EventsStates>(
            buildWhen: (pastState,currentState) => currentState is GetOpinionsAboutEventSuccessState || currentState is FailedToGetOpinionsAboutEventState,
            listener: (context,state)
            {
              if( state is FailedToGetOpinionsAboutEventState )
                {
                  showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: state is GetOpinionsAboutEventLoadingState ? const Center(child: CircularProgressIndicator()) :
                state is GetOpinionsAboutEventSuccessState && state.opinions.isNotEmpty ?
                ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.opinions.length,   // TODO: Events Related to Club I lead
                    separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                    itemBuilder: (context,index) => _opinionItem(index:index,context: context, opinionData: state.opinions[index]),
                ) : Center(
                  child: Text("لا توجدأراء حول الفعالية",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  // TODO: Three cases .. login - have logined - there is no place
  Widget _opinionItem({required BuildContext context,required int index,required OpinionAboutEventModel opinionData}){
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
        child: Text("${index+1} - ${opinionData.opinion!}",style: TextStyle(fontSize: 14.5.sp),),
      ),
    );
  }

}
