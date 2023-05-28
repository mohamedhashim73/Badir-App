import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';

PreferredSizeWidget appBarForHomeScreen({required ClubsCubit clubsCubit,required BuildContext context}){
  return AppBar(
    title: clubsCubit.searchEnabled ? TextField(
      style: TextStyle(color: AppColors.kWhiteColor),
      onChanged: (input)
      {
        clubsCubit.searchAboutClub(input: input);
      },
      decoration: InputDecoration(
          hintText: 'ادخل اسم النادي ....',
          hintStyle: TextStyle(color: AppColors.kWhiteColor,fontSize: 15.sp),
          border: InputBorder.none
      ),
    ) : const Text("الرئيسية"),
    automaticallyImplyLeading: Constants.userID != null ? true : false,
    actions:
    [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            GestureDetector(
              onTap: ()
              {
                clubsCubit.changeSearchAboutClubStatus();
              },
              child: clubsCubit.searchEnabled ? const Icon(Icons.clear) : const Icon(Icons.search),
            ),
            if( Constants.userID == null )
              SizedBox(width: 15.w,),
            if( Constants.userID == null )
              GestureDetector(
                onTap: ()
                {
                  Navigator.pushNamed(context, AppStrings.kLoginScreen);
                },
                child: Icon(Icons.person),
              ),
          ],
        ),
      ),
    ]
  );
}