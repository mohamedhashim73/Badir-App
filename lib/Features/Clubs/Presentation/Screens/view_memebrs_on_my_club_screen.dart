import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import 'display_member_data_screen.dart';

class ViewMembersOnMyClubScreen extends StatelessWidget {
  const ViewMembersOnMyClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    String idForClubILead = layoutCubit.userData!.idForClubLead!;
    ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    if( clubsCubit.membersDataOnMyClub.isEmpty ) clubsCubit.getMembersDataOnMyClub(layoutCubit: layoutCubit, idForClubILead: idForClubILead);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("بيانات الأعضاء"),),
          body: BlocConsumer<ClubsCubit,ClubsStates>(
            listener: (context,state)
            {
              if( state is RemoveMemberFromClubLoadingState ) showLoadingDialog(context: context);
              if( state is RemoveMemberFromClubSuccessState )
                {
                  Navigator.pop(context);
                  showToastMessage(context: context, message: 'تم حذف العضو بنجاح',backgroundColor: AppColors.kGreenColor);
                }
            },
            builder: (context,state)
            {
              if( state is GetMembersOnMyClubDataLoadingState )
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
              else
              {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  child: clubsCubit.membersDataOnMyClub.isNotEmpty ? ListView.builder(
                    itemCount: clubsCubit.membersDataOnMyClub.length,
                    itemBuilder: (context,index) => _displayMemberInfo(context:context,clubsCubit: clubsCubit,layoutCubit: layoutCubit,idForClubILead: idForClubILead,userEntity: clubsCubit.membersDataOnMyClub[index]),
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

  Widget _displayMemberInfo({required BuildContext context,required UserEntity userEntity,required ClubsCubit clubsCubit,required LayoutCubit layoutCubit,required String idForClubILead}) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayMemberDataScreen(userEntity:userEntity)));
      },
      child: Card(
        elevation: 0.1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              Text("العضو : ${userEntity.name!}",style: TextStyle(overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold,fontSize: 15.5.sp),),
              _buttonItem(
                  title: "حذف",
                  color: AppColors.kRedColor,
                  onTap: ()
                  {
                    clubsCubit.removeMemberFromCLubILead(idForClubILead: idForClubILead, memberID: userEntity.id!, layoutCubit: layoutCubit);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonItem({required String title,required Function() onTap,required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: color,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h),
        child: Text(title,style: TextStyle(color: AppColors.kWhiteColor),),
      ),
    );
  }

}
