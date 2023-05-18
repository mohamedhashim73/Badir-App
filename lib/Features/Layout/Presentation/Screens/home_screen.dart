import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/drawer_item.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../../../Events/Domain/Entities/event_entity.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Clubs/Presentation/Controller/clubs_states.dart';
import '../../../Events/Presentation/Controller/events_states.dart';
import '../../../Clubs/Presentation/Screens/club_details_screen.dart';
import '../../../Events/Presentation/Screens/event_details_screen.dart';
import '../../../Events/Presentation/Screens/send_opinion_about_event_screen.dart';
import '../../Domain/Entities/user_entity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = LayoutCubit.getInstance(context);
    if( layoutCubit.userData == null ) layoutCubit.getMyData();
    final clubsCubit = ClubsCubit.getInstance(context);
    if( clubsCubit.clubs.isEmpty ) clubsCubit.getClubsData();
    final eventsCubit = EventsCubit.getInstance(context);
    if( eventsCubit.allEvents.isEmpty ) eventsCubit.getAllEvents();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: DrawerItem(),
            appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("الرئيسية"),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 7.5.h),
            child: BlocConsumer<LayoutCubit,LayoutStates>(
              buildWhen: (pastState,currentState) => currentState is GetMyDataSuccessState ,
              listener: (context,state)
              {
                if( state is LogOutSuccessState ) Navigator.pushNamed(context, AppStrings.kLoginScreen);
                if( state is FailedToLogOut ) showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
              },
              builder: (context,state) {
                return layoutCubit.userData != null ? ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children:
                  [
                    _headingText(title: "احصائيات قد تهمك"),
                    SizedBox(height: 7.h,),
                    Row(
                      children:
                      [
                        Expanded(
                          child: BlocBuilder<ClubsCubit,ClubsStates>(
                            buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                            builder: (context,state) =>  _staticsDataItem(imagePath: "assets/images/clubs_num_icon.png", title: clubsCubit.clubs.length <= 10 ? "${clubsCubit.clubs.length} أندية" : "${clubsCubit.clubs.length} نادي"),
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                        [
                          _headingText(title: "الفعاليات"),
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
                              showSnackBar(context: context, message: state is FailedToJoinToEventState ? state.message : 'تم التسجيل بالفعالية بنجاح',backgroundColor: state is FailedToJoinToEventState ? AppColors.kRedColor : AppColors.kGreenColor);
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
                              itemCount: eventsCubit.allEvents.length > 2 ? 2 : eventsCubit.allEvents.length,  // TODO: لان مش عاوز غير بالكتير هم عنصرين فقط
                              itemBuilder: (context,index)
                              {
                                return LayoutBuilder(
                                  builder: (context,constraints)
                                  {
                                    // TODO: eventDate => لان محتاج اعرف اذا كانت الفعاليه عدت ولا لا
                                    DateTime eventDate = Jiffy("${eventsCubit.allEvents[index].endDate!.trim()} ${eventsCubit.allEvents[index].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
                                    return _displayEventOverView(eventsCubit: eventsCubit,myData: layoutCubit.userData!,context:context,eventEntity: eventsCubit.allEvents[index],eventExpired: DateTime.now().isAfter(eventDate) ? true : false, layoutCubit: layoutCubit);
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
                ) : const Center(child: CircularProgressIndicator());
              }
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

  Widget _displayEventOverView({required EventsCubit eventsCubit,required LayoutCubit layoutCubit,required UserEntity myData,required BuildContext context,required EventEntity eventEntity,required bool eventExpired}){
    bool eventExpiredAndIHaveNotJoined = Constants.eventExpiredAndIHaveNotJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData);
    bool eventExpiredAndIHaveJoined = Constants.eventExpiredAndIHaveJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData);
    bool eventInDateAndIHaveJoined = Constants.eventInDateAndIHaveJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData);
    bool eventInDateAndIHaveNotJoinedYetAndHavePermission = Constants.eventInDateAndIHaveNotJoinedYetAndHavePermission(userEntity: myData, eventExpired: eventExpired, event: eventEntity);
    bool eventInDateAndIDoNotHavePermissionToJoin = Constants.eventInDateAndIDoNotHavePermissionToJoin(userEntity: myData, eventExpired: eventExpired, event: eventEntity);
    return GestureDetector(
      onTap: ()
      {
        bool eventFinished = DateTime.now().isAfter(Jiffy("${eventEntity.endDate!.trim()} ${eventEntity.time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime);
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventExpired: eventFinished)));
      },
      child: Container(
        width: 160.w,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Text(eventEntity.description!,style: TextStyle(color: AppColors.kWhiteColor,overflow:TextOverflow.ellipsis,fontWeight: FontWeight.w500,fontSize: 12.sp),maxLines: 2,),
              ),
            ),
            SizedBox(width: 4.w,),
            Align(
                alignment: AlignmentDirectional.topEnd,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  onPressed: ()
                  {
                    if ( myData.idForClubLead != null )
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventExpired: false)));
                    }
                    else if( eventExpiredAndIHaveJoined )
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SendOpinionAboutEventScreen(eventName:eventEntity.name!,eventID:eventEntity.id!)));
                    }
                    else if( eventInDateAndIHaveNotJoinedYetAndHavePermission )
                    {
                      eventsCubit.joinToEvent(eventID: eventEntity.id!, layoutCubit: layoutCubit, memberID: myData.id ?? Constants.userID!);
                    }
                    else if( eventInDateAndIHaveJoined )
                    {
                      showSnackBar(context: context, message: "لقد سبق لك التسجيل بالفعالية",backgroundColor: AppColors.kRedColor);
                    }
                    else if( eventInDateAndIDoNotHavePermissionToJoin )
                    {
                      showSnackBar(context: context, message: 'هذه الفعالية خاصة بأعضاء ${eventEntity.clubName} فقط',backgroundColor: AppColors.kRedColor);
                    }
                  },
                  color: myData.idForClubLead != null || eventInDateAndIHaveNotJoinedYetAndHavePermission ? AppColors.kWhiteColor : eventInDateAndIHaveJoined || eventExpiredAndIHaveJoined ? AppColors.kOrangeColor : eventInDateAndIDoNotHavePermissionToJoin || eventExpiredAndIHaveNotJoined ? AppColors.kRedColor : AppColors.kOrangeColor,
                  textColor: myData.idForClubLead != null || Constants.eventInDateAndIHaveNotJoinedYetAndHavePermission(userEntity: myData, eventExpired: eventExpired, event: eventEntity) ? AppColors.kBlackColor : AppColors.kWhiteColor,
                  child: Text(myData.idForClubLead != null ? "متابعة" : eventInDateAndIHaveJoined ? "تم التسجيل" :  eventInDateAndIHaveNotJoinedYetAndHavePermission ? "سجل الآن" : eventExpiredAndIHaveNotJoined ? "انتهت الفعالية" : eventInDateAndIDoNotHavePermissionToJoin ? "خاصة" : "شاركنا برأيك",style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
              )
          ],
        ),
      ),
    );
  }

}
