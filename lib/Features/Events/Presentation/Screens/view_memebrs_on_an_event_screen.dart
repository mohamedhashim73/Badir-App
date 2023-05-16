import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/member_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import '../Controller/events_cubit.dart';

class ViewMembersOnAnEventScreen extends StatelessWidget {
  final String eventID;
  const ViewMembersOnAnEventScreen({Key? key,required this.eventID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventsCubit eventsCubit = EventsCubit.getInstance(context)..getMembersOnAnEvent(eventID: eventID);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("بيانات الأعضاء"),),
          body: BlocBuilder<ClubsCubit,ClubsStates>(
            buildWhen: (pastState,currentState) => currentState is GetMembersOnAnEventSuccessState || currentState is FailedToGetMembersOnAnEventDataState,
            builder: (context,state)
            {
              if( state is GetMemberOnAnEventLoadingState )
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
              else
              {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  child: eventsCubit.membersDataForAnEvent.isNotEmpty ? ListView.separated(
                    itemCount: eventsCubit.membersDataForAnEvent.length,
                    separatorBuilder: (context,index) => SizedBox(height: 10.h,),
                    itemBuilder: (context,index) => _displayMemberInfo(memberEntity: eventsCubit.membersDataForAnEvent[index]),
                  ) : Center(
                    child: Text("لم يتم إاضافة أي عضو للنادي حتي الآن",style: TextStyle(color: Colors.black26,fontSize: 15.sp),),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _displayMemberInfo({required MemberEntity memberEntity}) {
    return Card(
      elevation: 0.2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(memberEntity.memberName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),),
            SizedBox(height: 5.h,),
            Align(alignment: AlignmentDirectional.topEnd,child: Text(memberEntity.membershipDate,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp,color: AppColors.kYellowColor),)),
          ],
        ),
      ),
    );
  }

}
