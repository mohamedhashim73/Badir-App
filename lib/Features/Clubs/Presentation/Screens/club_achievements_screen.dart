import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Theme/app_colors.dart';

class ClubAchievementsScreen extends StatelessWidget {
  final ClubEntity club;
  const ClubAchievementsScreen({Key? key,required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("إحصائيات النادي"),),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children:
              [
                Text("نادي ${club.name!}",style: TextStyle(color: AppColors.kMainColor,fontWeight: FontWeight.bold,fontSize: 19.sp),),
                SizedBox(height: 10.h,),
                _titleUpperNumber(text: 'عدد الفعاليات',num: club.currentEventsNum ?? 0,url: "assets/images/clubs_num_icon.png"),
                SizedBox(height: 10.h,),
                _titleUpperNumber(text: 'عدد الأعضاء',num: club.numOfRegisteredMembers ?? 0,url: "assets/images/members_num_icon.png"),
                SizedBox(height: 10.h,),
                _titleUpperNumber(text: 'عدد الساعات التطوعية',num: club.volunteerHours ?? 0,url: "assets/images/clock_icon.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleUpperNumber({required String text,required String url,required int num}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
        [
          Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.5.sp),),
          Text("$num",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp)),
        ],
      ),
    );
  }

}
