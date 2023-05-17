import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TextUpperTextFormField extends StatelessWidget {
  final String text;
  const TextUpperTextFormField({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),)
    );
  }
}
