import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textFieldComponent({required TextEditingController controller,bool? isSecure,int? maxLines}){
  return Container(
    height: maxLines == null ? 45.h : null ,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 0.h),
    margin: EdgeInsets.only(bottom: 6.h),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      style: TextStyle(
          fontSize: 13.5.sp
      ),
      obscureText: isSecure ?? false,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none
      ),
    ),
  );
}