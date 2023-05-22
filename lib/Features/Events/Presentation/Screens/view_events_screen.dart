import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/send_opinion_about_event_screen.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Constants/enumeration.dart';
import 'event_details_screen.dart';

class ViewAllEventsThrowAppScreen extends StatelessWidget {
  const ViewAllEventsThrowAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsCubit eventCubit = EventsCubit.getInstance(context);
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    final UserEntity userEntity = layoutCubit.userData!;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("عرض الفعاليات"),
              bottom: const TabBar(
                tabs:
                [
                  Tab(child: Text("الفعاليات الحديثة"),),
                  Tab(child: Text("الفعاليات القديمة"),),
                ],
              ),
            ),
            body: BlocConsumer<EventsCubit,EventsStates>(
              listener: (context,state){},
              builder: (context,state){
                if( state is EventsClassifiedLoadingState )
                  {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                else
                  {
                    return TabBarView(
                      children:
                      [
                        _displayEvents(eventsCubit: eventCubit,layoutCubit: layoutCubit,userEntity: userEntity,context: context,newEventsOrNot: true,events: eventCubit.newEvents),
                        _displayEvents(eventsCubit:eventCubit,layoutCubit:layoutCubit,userEntity: userEntity,context: context,newEventsOrNot: false,events: eventCubit.pastEvents),
                      ],
                    );
                  }
              }
            )
          ),
        ),
      ),
    );
  }

  Widget _displayEvents({required EventsCubit eventsCubit,required LayoutCubit layoutCubit,required UserEntity userEntity,required List<EventEntity> events,required bool newEventsOrNot,required BuildContext context}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
      child: ListView.separated(
        itemCount: events.length,
        itemBuilder: (context,index)
        {
          // TODO: eventFinished use it to know if i will give my opinion or not
          bool eventFinished = DateTime.now().isAfter(Jiffy("${events[index].endDate!.trim()} ${events[index].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime);
          bool eventExpiredAndIHaveNotJoined = Constants.eventExpiredAndIHaveNotJoined(event: events[index],eventExpired: eventFinished,userEntity: userEntity);
          bool eventExpiredAndIHaveJoined = Constants.eventExpiredAndIHaveJoined(event: events[index],eventExpired: eventFinished,userEntity: userEntity);
          bool eventInDateAndIHaveJoined = Constants.eventInDateAndIHaveJoined(event: events[index],eventExpired: eventFinished,userEntity: userEntity);
          bool eventInDateAndIHaveNotJoinedYetAndHavePermission = Constants.eventInDateAndIHaveNotJoinedYetAndHavePermission(userEntity: userEntity, eventExpired: eventFinished, event: events[index]);
          bool eventInDateAndIDoNotHavePermissionToJoin = Constants.eventInDateAndIDoNotHavePermissionToJoin(userEntity: userEntity, eventExpired: eventFinished, event: events[index]);
          return GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: events[index],eventExpired: !newEventsOrNot)));
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    Text(events[index].name!,maxLines:1,style: TextStyle(overflow:TextOverflow.ellipsis,fontSize:16.sp,fontWeight:FontWeight.bold,color: AppColors.kRedColor),),
                    Text(events[index].description!,maxLines:3,style: const TextStyle(overflow:TextOverflow.ellipsis),),
                    Row(
                      children:
                      [
                        Text(events[index].startDate!.trim(),style: TextStyle(color: AppColors.kYellowColor),),
                        Text(" , ${events[index].location!.trim()}"),
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: MaterialButton(
                          elevation: 0,
                          color: userEntity.idForClubLead != null || eventInDateAndIHaveNotJoinedYetAndHavePermission ? AppColors.kMainColor : eventExpiredAndIHaveJoined ? AppColors.kOrangeColor : eventInDateAndIDoNotHavePermissionToJoin || eventExpiredAndIHaveNotJoined ? AppColors.kRedColor : AppColors.kGreenColor,
                          textColor: AppColors.kWhiteColor,
                          onPressed: ()
                            {
                              if ( userEntity.idForClubLead != null )
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: events[index],eventExpired: false)));
                              }
                              else if( eventExpiredAndIHaveJoined )
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SendOpinionAboutEventScreen(eventName:events[index].name!,eventID:events[index].id!)));
                              }
                              else if( eventInDateAndIHaveNotJoinedYetAndHavePermission )
                              {
                                eventsCubit.joinToEvent(eventID: events[index].id!, layoutCubit: layoutCubit, memberID: userEntity.id ?? Constants.userID!);
                              }
                              else if( eventInDateAndIHaveJoined )
                              {
                                showToastMessage(context: context, message: "لقد سبق لك التسجيل بالفعالية");
                              }
                              else if( eventInDateAndIDoNotHavePermissionToJoin )
                              {
                                showToastMessage(context: context, message: 'خاصة بأعضاء نادي ${events[index].clubName}',backgroundColor: AppColors.kRedColor);
                              }
                            },
                        child: Text(userEntity.idForClubLead != null ? "متابعة" : eventInDateAndIHaveJoined ? "تم التسجيل" :  eventInDateAndIHaveNotJoinedYetAndHavePermission ? "سجل الآن" : eventExpiredAndIHaveNotJoined ? "انتهت الفعالية" : eventInDateAndIDoNotHavePermissionToJoin ? "خاصة" : "شاركنا برأيك",style: const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context,index) => SizedBox(height: 10.h,),
      ),
    );
  }
}
