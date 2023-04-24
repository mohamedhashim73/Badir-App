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
  final Function() onTap;
  const DefaultButton({Key? key,required this.title,this.horizontalPaddingValue,this.verticalPaddingValue,this.width,this.height,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: horizontalPaddingValue ?? 5.w ,vertical: verticalPaddingValue ?? 6.h),
      color: AppColors.kMainColor,
      height: height,
      minWidth: width,
      textColor: AppColors.kWhiteColor,
      child: Text(title),
    );
  }
}
