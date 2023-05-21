import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import 'meeting_details_screen.dart';

class MeetingsManagementScreen extends StatelessWidget {
  const MeetingsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idForClubILead = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    if( clubsCubit.meetingsDataCreatedByMe.isEmpty ) clubsCubit.getMeetingsCreatedByMe(clubID: idForClubILead);
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
            buildWhen: (pastState,currentState) => currentState is GetMeetingCreatedBySuccessState,
            listener: (context,state)
            {
              if( state is DeleteMeetingLoadingState )
                {
                  showLoadingDialog(context:context);
                }
              if( state is DeleteMeetingSuccessState )
                {
                  Navigator.pop(context);   // To get out from Alert Dialog
                  showToastMessage(context: context, message: "تم حذف الاجتماع");
                }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: state is GetMeetingCreatedByLoadingState ? const Center(child: CircularProgressIndicator()) : clubsCubit.meetingsDataCreatedByMe.isNotEmpty && state is GetMeetingCreatedBySuccessState ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: clubsCubit.meetingsDataCreatedByMe.length,   // TODO: Events Related to Club I lead
                    separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                    itemBuilder: (context,index) => _meetingItem(cubit: clubsCubit,idForClubILead: idForClubILead,context: context,meetingEntity: clubsCubit.meetingsDataCreatedByMe[index])
                  ) : Center(
                    child: Text("لا توجد إجتماعات بعد",style: TextStyle(fontSize: 15.sp,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.bold),),
                  ),

              );
            }
          ),
        ),
      ),
    );
  }

  Widget _meetingItem({required String idForClubILead,required MeetingEntity meetingEntity,required BuildContext context,required ClubsCubit cubit}){
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetailsScreen(meetingEntity: meetingEntity,)));
      },
      child: Card(
        elevation: 0.1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
          child: Row(
            children:
            [
              Expanded(child: Text(meetingEntity.name!,style: TextStyle(fontSize:15.sp,fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis),)),
              _buttonItem(
                  title: 'حذف',
                  onTap: ()
                  {
                    cubit.deleteMeeting(meetingID: meetingEntity.id!,clubID: idForClubILead);
                  }
              ),
            ],
          ),
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
