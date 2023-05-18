import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SendOpinionAboutEventScreen extends StatelessWidget {
  const SendOpinionAboutEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("شاركنا برأيك"),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("رأيك مسموع ويهمنا !!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.5.sp,color: AppColors.kYellowColor),),
                SizedBox(height: 20.h,),
                Card(
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w)
                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                MaterialButton(
                  onPressed: ()
                  {

                  },
                  elevation: 0,
                  textColor: AppColors.kWhiteColor,
                  color: AppColors.kMainColor,
                  height: 35.h,
                  minWidth: 120.w,
                  child: Text("إرسال",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
