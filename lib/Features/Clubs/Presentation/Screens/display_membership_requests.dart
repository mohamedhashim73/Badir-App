import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/request_membership_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Components/display_member_info_item.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controller/clubs_cubit.dart';
import '../Controller/clubs_states.dart';

class MembershipRequestsScreen extends StatelessWidget {
  const MembershipRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = LayoutCubit.getInstance(context);
    String clubID = layoutCubit.userData!.idForClubLead!;
    final cubit = ClubsCubit.getInstance(context)..getMembershipRequests(clubID: clubID);
    String clubName = cubit.dataAboutClubYouLead!.name!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("طلبات العضوية"),),
        body: BlocConsumer<ClubsCubit,ClubsStates>(
          buildWhen: (last,currentState) => currentState is GetMembershipRequestSuccessState,
          listener: (context,state)
          {
            if( state is AcceptOrRejectMembershipRequestSuccessState )
              {
                Navigator.pop(context);   // TODO: To get out from Alert Dialog ( showLoadingDialog )
                cubit.getMembershipRequests(clubID: clubID);
              }
            if( state is AcceptOrRejectMembershipRequestLoadingState )
              {
                showLoadingDialog(context: context);
              }
          },
          builder: (context,state){
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
                child: cubit.membershipRequests.isNotEmpty ?
                    ListView.separated(
                      itemCount: cubit.membershipRequests.length,
                      separatorBuilder: (context,index) => SizedBox(height: 12.h,),
                      itemBuilder: (context,index)
                      {
                        return _requestMembershipItem(context:context,clubName:clubName,layoutCubit:layoutCubit,cubit: cubit,requestData: cubit.membershipRequests[index],clubID: clubID);
                      },
                    ) : state is GetMembershipRequestLoadingState ?
                    CircularProgressIndicator(color: AppColors.kMainColor,) :
                    Text("لا توجد طلبات حتي الآن",style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 15.5.sp))
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _requestMembershipItem({required BuildContext context,required RequestMembershipEntity requestData,required LayoutCubit layoutCubit,required ClubsCubit cubit,required String clubID,required String clubName}){
  return InkWell(
    onTap: () => showMemberData(context: context, committeeName: requestData.committeeName!, aboutMember: requestData.infoAboutSender!),
    child: Card(
      elevation: 0.2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(requestData.senderName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.5.sp),),
            SizedBox(height: 5.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
              [
                _buttonItem(requestSenderFirebaseFCMToken: requestData.senderFirebaseFCMToken,committeeNameForRequestSender: requestData.committeeName,clubID: clubID,cubit: cubit,responseStatus: true,requestSenderID: requestData.senderID!,layoutCubit: layoutCubit,clubName: clubName),
                SizedBox(width: 7.5.w,),
                _buttonItem(requestSenderFirebaseFCMToken: requestData.senderFirebaseFCMToken,committeeNameForRequestSender: requestData.committeeName,clubID: clubID,cubit: cubit,responseStatus: false,requestSenderID: requestData.senderID!,layoutCubit: layoutCubit,clubName: clubName),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buttonItem({required bool responseStatus,required ClubsCubit cubit,required String committeeNameForRequestSender,required String requestSenderID,String? requestSenderFirebaseFCMToken,required String clubID,required String clubName,required LayoutCubit layoutCubit}){
  return MaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    height: 30.h,
    onPressed: () => cubit.acceptOrRejectMembershipRequest(receiverFirebaseMessagingToken: requestSenderFirebaseFCMToken,committeeNameForRequestSender: committeeNameForRequestSender,idForClubILead: clubID,requestSenderID: requestSenderID, clubID: clubID, respondStatus: responseStatus,layoutCubit: layoutCubit,clubName: clubName),
    color: responseStatus ? AppColors.kGreenColor : AppColors.kRedColor,
    child: Text(responseStatus ? 'قبول' : "رفض",)
  );
}
