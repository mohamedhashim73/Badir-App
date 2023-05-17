import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textFieldComponent({double? verticalPaddingValue,String? labelText,required TextEditingController controller,bool? isSecure,int? maxLines,bool enabled = true,TextInputType? textInputType}){
  return Container(
    height: maxLines == null ? 45.h : null ,
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 6.h),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    child: TextFormField(
      enabled: enabled,
      keyboardType: textInputType ?? TextInputType.name,
      controller: controller,
      maxLines: maxLines ?? 1,
      style: TextStyle(
          fontSize: 13.5.sp
      ),
      obscureText: isSecure ?? false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: verticalPaddingValue ?? 5.h,horizontal: 8.w),
          labelText: labelText,
          border: InputBorder.none
      ),
    ),
  );
}