import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Layout/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Clubs_Cubit/clubs_cubit.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Clubs_Cubit/clubs_states.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Events_Cubit/events_cubit.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Events_Cubit/events_states.dart';
import 'package:bader_user_app/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Theme/app_colors.dart';
import 'club_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = LayoutCubit.getInstance(context);
    final clubsCubit = ClubsCubit.getInstance(context);
    final eventsCubit = EventsCubit.getInstance(context);
    if(clubsCubit.clubs.isEmpty) clubsCubit.getClubsData();
    if(eventsCubit.events.isEmpty) eventsCubit.getEventsData();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("الرئيسية"),
              automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 7.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                _headingText(title: "احصائيات تهمك"),
                SizedBox(height: 7.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    BlocBuilder<ClubsCubit,ClubsStates>(
                        buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                        builder: (context,state) =>  _staticsDataItem(imagePath: "assets/images/clubs_num_icon.png", title: clubsCubit.clubs.length <= 10 ? "${clubsCubit.clubs.length} أندية" : "${clubsCubit.clubs.length} نادي"),
                    ),
                    _staticsDataItem(imagePath: "assets/images/clock_icon.png", title: "0 ساعة"),
                    _staticsDataItem(imagePath: "assets/images/members_num_icon.png", title: "0 عضو"),
                  ],
                ),
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    _headingText(title: "الأندية الطلابية"),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.pushNamed(context, AppStrings.kViewClubsScreen);
                      },
                      child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                    )
                  ],
                ),
                SizedBox(height: 7.h,),
                BlocBuilder<ClubsCubit,ClubsStates>(
                  buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                  builder: (context,state) {
                    return clubsCubit.clubs.isNotEmpty ?
                    SizedBox(
                      width: double.infinity,
                      height: 120.h,
                      child: ListView.separated(
                        separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: clubsCubit.clubs.length,
                        itemBuilder: (context,index)
                        {
                          return LayoutBuilder(
                            builder: (context,constraints)
                            {
                              return _displayClubOverView(context:context,clubEntity: clubsCubit.clubs[index],maxWidth: constraints.maxWidth,maxHeight: constraints.maxHeight);
                            },
                          );
                        },
                      ),
                    ) : SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: Text("لا يتم اضافة أندية حتي الآن",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15.5.sp,fontWeight: FontWeight.w400),),
                    );
                  }
                ),
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    _headingText(title: "الفعاليات القادمة"),
                    GestureDetector(
                      onTap: ()
                      {

                      },
                      child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                    )
                  ],
                ),
                SizedBox(height: 12.h,),
                BlocBuilder<EventsCubit,EventsStates>(
                    buildWhen: (previousState,currentState) => currentState is GetEventsDataSuccessState && previousState != currentState,
                    builder: (context,state) {
                      return eventsCubit.events.isNotEmpty ?
                      SizedBox(
                        width: double.infinity,
                        height: 120.h,
                        child: ListView.separated(
                          separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: eventsCubit.events.length,
                          itemBuilder: (context,index)
                          {
                            return LayoutBuilder(
                              builder: (context,constraints)
                              {
                                return _displayEventOverView(context:context,eventEntity: eventsCubit.events[index]);
                              },
                            );
                          },
                        ),
                      ) : SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: Text("لا يتم اضافة فعاليات بعد",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15.5.sp,fontWeight: FontWeight.w400),),
                      );
                    }
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _staticsDataItem({required String imagePath,required String title}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
      [
        Image.asset(imagePath,height: 70.h,width: 70.w,),
        SizedBox(height: 2.5.h,),
        FittedBox(fit:BoxFit.scaleDown,child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),))
      ],
    );
  }

  Widget _headingText({required String title}) {
    return Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),);
  }

  Widget _displayClubOverView({required ClubEntity clubEntity,required double maxHeight,required double maxWidth,required BuildContext context}){
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: clubEntity)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            color: AppColors.kMainColor,
            borderRadius: BorderRadius.circular(4.w)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:
          [
            FittedBox(fit:BoxFit.scaleDown,child: Text(clubEntity.name,style: TextStyle(color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 15.sp),)),
            SizedBox(width: 10.w,),
            CircleAvatar(
              radius: 28.w,
              backgroundImage: clubEntity.image.isNotEmpty ? NetworkImage(clubEntity.image) : null,
              backgroundColor: clubEntity.image.isNotEmpty ? null : Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget _displayEventOverView({required BuildContext context,required EventEntity eventEntity}){
    return GestureDetector(
      onTap: ()
      {
        // TODO: Open Event Details
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.kMainColor,
          borderRadius: BorderRadius.circular(4.w)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text("# ${eventEntity.name}",maxLines:2,style: TextStyle(color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 15.sp),),
            Expanded(
              child: Text(eventEntity.description,style: TextStyle(color: AppColors.kWhiteColor,fontWeight: FontWeight.w500,fontSize: 15.sp),),
            ),
            SizedBox(width: 4.w,),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: ()
                {

                },
                textColor: AppColors.kMainColor,
                color: AppColors.kWhiteColor,
                child: const Text("انضم إلينا",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }

}
