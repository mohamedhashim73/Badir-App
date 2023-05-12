import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/event_details_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';

class MeetingsManagementScreen extends StatelessWidget {
  const MeetingsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idForClubILead = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    // if( eventCubit.ownEvents.isEmpty ) eventCubit.getPastAndNewAndMyEvents(idForClubILead: idForClubILead);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("إدارة الإجتماعات"),),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, AppStrings.kCreateMeetingScreen);
            },
            backgroundColor: AppColors.kMainColor,
            child: const Icon(Icons.add),
          ),
          body: BlocConsumer<ClubsCubit,ClubsStates>(
            // buildWhen: (past,currentState) => currentState is EventsClassifiedSuccessState,
            listener: (context,state)
            {
              // if( state is DeleteEventLoadingState )
              //   {
              //     // Loading Text will be shown to User...
              //     showLoadingDialog(context:context);
              //   }
              // if( state is DeleteEventSuccessState )
              //   {
              //     Navigator.pop(context);   // To get out from Alert Dialog
              //   }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: Center(
                  child: Text("لا توجد إجتماعات بعد",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                ),
                  // TODO: SHOW MEETINGS
                  /*
                  state is EventsClassifiedLoadingState ? const Center(child: CircularProgressIndicator()) : eventCubit.ownEvents.isNotEmpty ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: eventCubit.ownEvents.length,   // TODO: Events Related to Club I lead
                  separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                  itemBuilder: (context,index) => _eventItem(idForClubILead: idForClubILead,cubit:eventCubit,context: context,eventData: eventCubit.ownEvents[index])
                ) : Center(
                  child: Text("لا توجد فعاليات بعد",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                ),
                   */
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _meetingItem({required String idForClubILead,required MeetingEntity meetingEntity,required BuildContext context,required EventsCubit cubit}){
    return GestureDetector(
      onTap: ()
      {

      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
        color: AppColors.kYellowColor,
        child: Row(
          children:
          [
            Expanded(child: Text(meetingEntity.name!,style: const TextStyle(fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis),)),
            _buttonItem(
                title: 'حذف',
                onTap: ()
                {
                  // cubit.deleteMeeting(meetingID: meetingEntity.id!,idForClubILead: idForClubILead);
                }
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
