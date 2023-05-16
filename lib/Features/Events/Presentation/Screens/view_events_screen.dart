import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Constants/enumeration.dart';
import 'event_details_screen.dart';

class ViewAllEventsThrowAppScreen extends StatelessWidget {
  const ViewAllEventsThrowAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsCubit eventCubit = EventsCubit.getInstance(context);
    final UserEntity userEntity = LayoutCubit.getInstance(context).userData!;
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
                        _displayEvents(userEntity: userEntity,context: context,newEventsOrNot: true,events: eventCubit.newEvents),
                        _displayEvents(userEntity: userEntity,context: context,newEventsOrNot: false,events: eventCubit.pastEvents),
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

  Widget _displayEvents({required UserEntity userEntity,required List<EventEntity> events,required bool newEventsOrNot,required BuildContext context}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
      child: ListView.separated(
        itemCount: events.length,
        itemBuilder: (context,index)
        {
          return GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: events[index],eventDateExpired: !newEventsOrNot)));
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
                          color: userEntity.idForClubLead != null ? AppColors.kOrangeColor : userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(events[index].id) == false ? AppColors.kRedColor : AppColors.kMainColor,
                          textColor: AppColors.kWhiteColor,
                          onPressed: ()
                          {
                            if( userEntity.idForClubLead != null )
                              {
                                // TODO: Open Details ....
                              }
                            else if ( userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(events[index].id) == false && newEventsOrNot == true )
                              {
                                // TODO: Join to Event Function ...
                              }
                            else if ( userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(events[index].id) == false && newEventsOrNot == false )
                              {
                                // TODO: Give opinion Function ...
                              }
                            else
                              {
                                showSnackBar(context: context, message: "هذا الفعالية خاصة بأعضاء نادي ${events[index].name}",backgroundColor: AppColors.kRedColor);
                              }
                          },
                          child: Text(userEntity.idForClubLead != null ? "متابعة" : userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(events[index].id) == false ? "خاصة" : newEventsOrNot ? 'انضمام' : 'شاركنا برأيك')
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
