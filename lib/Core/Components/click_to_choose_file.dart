import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClickToChooseFile extends StatelessWidget {
  final Function() onTap;
  final String text;
  const ClickToChooseFile({Key? key,required this.onTap,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            const Icon(Icons.image,color: Colors.green,),
            SizedBox(width: 10.w,),
            Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.5.sp),)
          ],
        ),
      ),
    );
  }
}
