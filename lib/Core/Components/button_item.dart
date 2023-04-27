import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Theme/app_colors.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? horizontalPaddingValue;
  final double? verticalPaddingValue;
  final double? height;
  final Color? backgroundColor;
  final Function() onTap;
  final ShapeBorder? roundedRectangleBorder;
  DefaultButton({Key? key,this.roundedRectangleBorder,this.backgroundColor,required this.title,this.horizontalPaddingValue,this.verticalPaddingValue,this.width,this.height,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 0,
      shape: roundedRectangleBorder,
      padding: EdgeInsets.symmetric(horizontal: horizontalPaddingValue ?? 5.w ,vertical: verticalPaddingValue ?? 6.h),
      color: backgroundColor ?? AppColors.kMainColor,
      height: height,
      minWidth: width,
      textColor: AppColors.kWhiteColor,
      child: Text(title,style: TextStyle(fontSize: 14.5.sp),),
    );
  }
}
