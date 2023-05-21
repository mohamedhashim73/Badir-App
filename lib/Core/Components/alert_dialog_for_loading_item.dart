import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showLoadingDialog({required BuildContext context}) {
  showDialog(context: context, builder: (context) => AlertDialog(
    content: Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
        [
          const CupertinoActivityIndicator(),
          SizedBox(width: 10.w,),
          const Text('برجاء الإنتظار')
        ],
      ),
    ),
  )
  );
}