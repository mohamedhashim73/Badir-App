import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadingText extends StatelessWidget {
  final String title;
  const HeadingText({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),);
  }
}

