import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewClubContactMeansScreen extends StatelessWidget {
  final ContactMeansForClub contactMeansForClub;
  const ViewClubContactMeansScreen({Key? key,required this.contactMeansForClub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("وسائل التواصل بالنادي"),),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.5.w),
            child: BlocListener<LayoutCubit,LayoutStates>(
              listener: (context,state)
              {
                if( state is ErrorDuringOpenPdfState )
                  {
                    showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                  }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  Text("يمكنك التواصل مع النادي من خلال \n الحسابات التالية",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 17.sp),),
                  SizedBox(height: 15.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      InkWell(
                          onTap:()
                          {
                            layoutCubit.openPdf(link: contactMeansForClub.email!);
                          },
                          child: Image.asset("assets/images/gmail.png",height: 52.h,width: 52.w,)
                      ),
                      SizedBox(width: 30.w,),
                      InkWell(
                          onTap:()
                          {
                            layoutCubit.openPdf(link: contactMeansForClub.twitter!);
                          },
                          child: Image.asset("assets/images/twitter.png",height: 52.h,width: 52.w,)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
