import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Events/Presentation/Screens/view_events_on_specific_club_screen.dart';
class ViewClubDetailsScreen extends StatelessWidget {
  final ClubEntity club;
  const ViewClubDetailsScreen({Key? key,required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text("تفاصيل النادي")),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical:12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Row(
                  children:
                  [
                    Expanded(child: Text("نادي ${club.name!}",style: TextStyle(color: AppColors.kMainColor,fontWeight: FontWeight.bold,fontSize: 18.5.sp),)),
                    SizedBox(width: 10.w,),
                    if( club.image != null )
                      CircleAvatar(
                        radius: 50.h,
                        backgroundImage: NetworkImage(club.image!),
                      ),
                  ],
                ),
                SizedBox(height: 7.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    _otherDetailsComponent(
                        imagePath: "assets/images/buffer_icon.png",
                        title: "الفعاليات",
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOnSpecificClubScreen(clubID: club.id.toString(),clubName: club.name!,)));
                        }
                    ),
                    _otherDetailsComponent(
                        imagePath: "assets/images/badge_icon.png",
                        title: "الإنجازات",
                        onTap: ()
                        {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOnSpecificClubScreen(clubID: club.id.toString(),clubName: club.name!,)));
                        }
                    ),
                    _otherDetailsComponent(
                        imagePath: "assets/images/chat_icon.png",
                        title: "تواصل معنا",
                        onTap: ()
                        {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventsOnSpecificClubScreen(clubID: club.id.toString(),clubName: club.name!,)));
                        }
                    ),
                  ],
                ),
                SizedBox(height: 7.h,),
                Text("عن النادي",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                SizedBox(height: 10.h,),
                Container(
                  width: double.infinity,
                  alignment: club.description != null ? AlignmentDirectional.center : AlignmentDirectional.topStart,
                  padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(club.description != null ? club.description! : "لم يتم اضافة وصف للنادي حتي الآن",style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _otherDetailsComponent({required String imagePath,required String title,required Function() onTap}){
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children:
      [
        FittedBox(fit:BoxFit.scaleDown,child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),)),
        SizedBox(height: 7.5.h,),
        Image.asset(imagePath,height: 52.h,width: 52.w,),
      ],
    ),
  );
}

