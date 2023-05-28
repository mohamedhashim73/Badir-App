import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaticsDataWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  const StaticsDataWidget({Key? key,required this.imagePath,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
      [
        Image.asset(imagePath,height: 70.h,width: 70.w,),
        SizedBox(height: 2.5.h,),
        FittedBox(fit:BoxFit.scaleDown,child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),))
      ],
    );
  }
}

