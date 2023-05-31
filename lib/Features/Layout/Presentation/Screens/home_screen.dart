import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Widgets/heading_text.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Widgets/statics_data_item.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/awesome_dialog_to_ask_visitor_to_login_first.dart';
import '../../../../Core/Components/drawer_item.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Clubs/Presentation/Controller/clubs_states.dart';
import '../../../Events/Presentation/Controller/events_states.dart';
import '../Widgets/appBar_for_home_screen_widget.dart';
import '../Widgets/view_clubs_on_home_screen_widget.dart';
import '../Widgets/view_events_on_home_screen_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = LayoutCubit.getInstance(context);
    if( layoutCubit.userData == null && Constants.userID != null ) layoutCubit.getMyData();
    final clubsCubit = ClubsCubit.getInstance(context);
    final eventsCubit = EventsCubit.getInstance(context);
    if( eventsCubit.allEvents.isEmpty ) eventsCubit.getAllEvents();
    if( clubsCubit.clubs.isEmpty ) clubsCubit.getAllClubs(userEntity: layoutCubit.userData);
    return BlocBuilder<LayoutCubit,LayoutStates>(
        buildWhen: (pastState,currentState) => currentState is GetMyDataSuccessState,
        builder: (context,state) {
        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocBuilder<ClubsCubit,ClubsStates>(
              buildWhen: (pastState,currentState) => currentState is ChangeSearchAboutClubStatus,
              builder: (context,state) {
                return Scaffold(
                    drawer: Constants.userID != null ? DrawerItem() : null,
                    appBar: appBarForHomeScreen(clubsCubit: clubsCubit,context: context),
                    body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 7.5.h),
                      child: layoutCubit.userData != null || Constants.userID == null ?
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          children:
                          [
                            HeadingText(title: "احصائيات قد تهمك"),
                            SizedBox(height: 7.h,),
                            Row(
                              children:
                              [
                                Expanded(
                                  child: BlocBuilder<ClubsCubit,ClubsStates>(
                                    buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                                    builder: (context,state) =>  StaticsDataWidget(imagePath: "assets/images/clubs_num_icon.png", title: clubsCubit.clubs.length <= 10 ? "${clubsCubit.clubs.length} أندية" : "${clubsCubit.clubs.length} نادي"),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children:
                                    [
                                      Image.asset("assets/images/clock_icon.png",height: 70.h,width: 70.w,),
                                      SizedBox(height: 2.5.h,),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection(Constants.kTotalVolunteerHoursThrowAppCollectionName).doc('Number').snapshots(),
                                        builder: (context,event)
                                        {
                                          if( event.hasData )
                                          {
                                            int volunteerHours = event.data!.data() != null ? event.data!.data()!['total'] : 0;
                                            return FittedBox(fit:BoxFit.scaleDown,child: Text(volunteerHours > 10 ? "$volunteerHours ساعة" : "$volunteerHours ساعات",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                          }
                                          else
                                          {
                                            return FittedBox(fit:BoxFit.scaleDown,child: Text("0 ساعة",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children:
                                    [
                                      Image.asset("assets/images/members_num_icon.png",height: 70.h,width: 70.w,),
                                      SizedBox(height: 2.5.h,),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection(Constants.kMembersNumberCollectionName).doc('Number').snapshots(),
                                        builder: (context,event)
                                        {
                                          if( event.hasData )
                                          {
                                            int membersNum = event.data!.data() != null ? event.data!.data()!['total'] : 0;
                                            return FittedBox(fit:BoxFit.scaleDown,child: Text(membersNum > 10 ? "$membersNum عضو" : "$membersNum أعضاء",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                          }
                                          else
                                          {
                                            return FittedBox(fit:BoxFit.scaleDown,child: Text("لا يوجد أعضاء",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12.h,),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:
                                [
                                  HeadingText(title: "الأندية الطلابية"),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      Navigator.pushNamed(context, AppStrings.kViewClubsScreen);
                                    },
                                    child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 7.h,),
                            BlocBuilder<ClubsCubit,ClubsStates>(
                                buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState || currentState is GetFilteredClubsSuccessState,
                                builder: (context,state) {
                                  return clubsCubit.clubs.isNotEmpty ?
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120.h,
                                    child: ListView.separated(
                                      separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs.length : clubsCubit.filteredClubsData.length,
                                      itemBuilder: (context,index)
                                      {
                                        return LayoutBuilder(
                                          builder: (context,constraints)
                                          {
                                            return ClubItemOnHomeScreen(context:context,clubEntity: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs[index] : clubsCubit.filteredClubsData[index],maxWidth: constraints.maxWidth,maxHeight: constraints.maxHeight);
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
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:
                                [
                                  HeadingText(title: "الفعاليات"),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      Navigator.pushNamed(context, AppStrings.kPastAndNewEventsScreen);
                                    },
                                    child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h,),
                            BlocConsumer<EventsCubit,EventsStates>(
                                buildWhen: (previousState,currentState) => currentState is GetEventsDataSuccessState && previousState != currentState,
                                listener: (context,state)
                                {
                                  if( state is JoinToEventLoadingState )
                                  {
                                    showLoadingDialog(context: context);
                                  }
                                  if( state is JoinToEventSuccessState || state is FailedToJoinToEventState )
                                  {
                                    Navigator.pop(context);    // TODO: Get out from Alert Dialog...
                                    showToastMessage(context: context, message: state is FailedToJoinToEventState ? state.message : 'تم التسجيل بالفعالية بنجاح',backgroundColor: state is FailedToJoinToEventState ? AppColors.kRedColor : AppColors.kGreenColor);
                                  }
                                },
                                builder: (context,state) {
                                  return eventsCubit.allEvents.isNotEmpty ?
                                  SizedBox(
                                    width: double.infinity,
                                    height: 200.h,
                                    child: ListView.separated(
                                      separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: eventsCubit.allEvents.length,  // TODO: لان مش عاوز غير بالكتير هم عنصرين فقط
                                      itemBuilder: (context,index)
                                      {
                                        return LayoutBuilder(
                                          builder: (context,constraints)
                                          {
                                            // TODO: eventDate => لان محتاج اعرف اذا كانت الفعاليه عدت ولا لا
                                            DateTime eventDate = Jiffy("${eventsCubit.allEvents[index].endDate!.trim()} ${eventsCubit.allEvents[index].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
                                            debugPrint("Event Date is : $eventDate, with id : ${eventsCubit.allEvents[index].id}");
                                            return EventItemOnHomeScreen(eventsCubit: eventsCubit,myData: Constants.userID != null ? layoutCubit.userData! : null ,context:context,eventEntity: eventsCubit.allEvents[index],eventExpired: DateTime.now().isAfter(eventDate) ? true : false, layoutCubit: layoutCubit);
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
                        ) :
                        const Center(child: CircularProgressIndicator())
                    )
                );
              }
            ),
          ),
        );
      }
    );
  }

}
