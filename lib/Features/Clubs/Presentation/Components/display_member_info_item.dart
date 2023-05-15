import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showMemberData({required BuildContext context,required String committeeName,required String aboutMember}) {
  showDialog(context: context, builder: (context) => Directionality(
    textDirection: TextDirection.rtl,
    child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Center(child: Text("بيانات صاحب الطلب",style: TextStyle(fontWeight:FontWeight.bold,color: AppColors.kRedColor,fontSize: 18.sp),)),
            SizedBox(height: 5.h,),
            Text("اللجنة",style: TextStyle(color: AppColors.kMainColor,fontSize: 16.sp),),
            SizedBox(height: 5.h),
            _containerItem(text: committeeName),
            Text("عن العضو",style: TextStyle(color: AppColors.kMainColor,fontSize: 16.sp)),
            SizedBox(height: 5.h),
            _containerItem(text: aboutMember,maxLines: 6)
          ],
        )
    ),
  ));
}

Widget _containerItem({required String text,int maxLines = 1}) => Container(
  width: double.infinity,
  padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
  margin: EdgeInsets.only(bottom: 6.h),
  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
  child: SingleChildScrollView(physics: const BouncingScrollPhysics(),child: Text(text,maxLines:maxLines,style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 14.sp),)),
);
