import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../../../Clubs/Domain/Entities/club_entity.dart';
import '../../../Clubs/Presentation/Screens/club_details_screen.dart';

class ClubItemOnHomeScreen extends StatelessWidget {
  final ClubEntity clubEntity;
  final double maxHeight;
  final double maxWidth;
  final BuildContext context;
  const ClubItemOnHomeScreen({Key? key,required this.clubEntity,required this.maxHeight,required this.context,required this.maxWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: clubEntity)));
      },
      child: Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
            color: AppColors.kMainColor,
            borderRadius: BorderRadius.circular(4.w)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:
          [
            Expanded(child: Text(clubEntity.name!,maxLines:1,style: TextStyle(overflow:TextOverflow.ellipsis,color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 16.sp),)),
            SizedBox(width: 7.5.w,),
            CircleAvatar(
              radius: 28.w,
              backgroundImage: clubEntity.image != null ? NetworkImage(clubEntity.image!) : null,
              backgroundColor: clubEntity.image != null ? null : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}


