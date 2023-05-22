import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget dropDownComponent({required List<String> items,required void Function(String?)? onChanged,String? value}){
  return Container(
    height: 45.h,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 0.h),
    margin: EdgeInsets.only(bottom: 6.h),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: const Text("اختار"),
        value: value,
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value:e,child: Directionality(textDirection:TextDirection.rtl,child: Align(alignment:AlignmentDirectional.centerStart,child: Text(e),)))).toList(),
      ),
    ),
  );
}