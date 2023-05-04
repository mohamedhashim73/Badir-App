import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ViewClubDetailsScreen extends StatelessWidget {
  final ClubEntity club;
  const ViewClubDetailsScreen({Key? key,required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text("تفاصيل النادي"),automaticallyImplyLeading: false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical:10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    Text(club.name,style: TextStyle(color: AppColors.kYellowColor,fontWeight: FontWeight.bold,fontSize: 20.sp),),
                    if( club.image.isNotEmpty )
                      Container(
                        height: 80.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(club.image)),
                            border: Border.all(color: Colors.black.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 7.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    _otherDetailsComponent(imagePath: "assets/images/buffer_icon.png", title: "الفعاليات"),
                    _otherDetailsComponent(imagePath: "assets/images/badge_icon.png", title: "الإنجازات"),
                    _otherDetailsComponent(imagePath: "assets/images/chat_icon.png", title: "تواصل معنا"),
                  ],
                ),
                SizedBox(height: 7.h,),
                Text("عن النادي",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                SizedBox(height: 10.h,),
                Container(
                  width: double.infinity,
                  alignment: club.description.isEmpty ? AlignmentDirectional.center : AlignmentDirectional.topStart,
                  padding: EdgeInsets.symmetric(vertical: club.description.isNotEmpty? 7.5.h : 20.h,horizontal: 7.5.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(club.description.isNotEmpty ? club.description : "لم يتم اضافة وصف للنادي حتي الآن",style: TextStyle(fontSize: 14.5.sp,fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _otherDetailsComponent({required String imagePath,required String title}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children:
    [
      FittedBox(fit:BoxFit.scaleDown,child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),)),
      SizedBox(height: 7.5.h,),
      Image.asset(imagePath,height: 52.h,width: 52.w,),
    ],
  );
}

