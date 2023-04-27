import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBar({required BuildContext context, required String message, Color? backgroundColor,int? seconds}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: seconds ?? 1),
          backgroundColor: backgroundColor ?? Colors.black,
          padding: EdgeInsets.symmetric(vertical: 12.5.h,horizontal: 12.w),
          content: Text(message,style: TextStyle(color: Colors.white,fontSize: 15.sp),))
  );
}