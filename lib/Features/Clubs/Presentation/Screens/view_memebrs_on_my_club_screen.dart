import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          body: BlocBuilder<ClubsCubit,ClubsStates>(
            buildWhen: (pastState,currentState) => currentState is GetMembersOnMyClubDataSuccessState ,
            builder: (context,state){
              if( state is GetMembersOnMyClubDataLoadingState )
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
              else
              {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  child: ListView.builder(
                    itemCount: clubsCubit.membersDataOnMyClub.length,
                    itemBuilder: (context,index) => _displayMemberInfo(userEntity: clubsCubit.membersDataOnMyClub[index]),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _displayMemberInfo({required UserEntity userEntity}) {
    return Card(
      color: AppColors.kGreyColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
        child: Text(userEntity.name!,style: TextStyle(overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold,fontSize: 15.5.sp),),
      ),
    );
  }
}
