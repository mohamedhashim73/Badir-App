import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/event_details_screen.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
class EventsManagementScreen extends StatelessWidget {
  const EventsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idForClubThatYouLead = LayoutCubit.getInstance(context).userData!.clubIDThatHeLead!;
    final eventCubit = EventsCubit.getInstance(context);
    if( eventCubit.ownEvents.isEmpty ) eventCubit.getEventsCreatedByMe(idForClubThatYouLead: idForClubThatYouLead);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("إدارة الفعاليات"),),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, AppStrings.kCreateEventScreen);
            },
            backgroundColor: AppColors.kMainColor,
            child: const Icon(Icons.add),
          ),
          body: BlocBuilder<EventsCubit,EventsStates>(
            buildWhen: (past,currentState) => currentState is GetEventsCreatedByMeSuccessState,
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: eventCubit.ownEvents.length,
                  separatorBuilder: (context,index) => SizedBox(height: 15.h,),
                  itemBuilder: (context,index) => _eventItem(context: context,eventData: eventCubit.ownEvents[index])
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _eventItem({required EventEntity eventData,required BuildContext context}){
    return GestureDetector(
      onTap: ()
      {
        // TODO: USE Event Date to Compare it with Date now to see if it expired or not
        DateTime eventDate = Jiffy("${eventData.endDate!.trim()} ${eventData.time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventData, eventDateExpired: DateTime.now().isAfter(eventDate))));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
        color: AppColors.kYellowColor,
        child: Row(
          children:
          [
            Expanded(child: Text(eventData.name!,style: const TextStyle(fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis),)),
            _buttonItem(title: 'تحديث', onTap: (){},),
            SizedBox(width: 5.w,),
            _buttonItem(title: 'المسجلين', onTap: (){}),
            SizedBox(width: 5.w,),
            _buttonItem(title: 'حذف', onTap: (){}),
          ],
        ),
      ),
    );
  }

  Widget _buttonItem({required String title,required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: AppColors.kMainColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 3.h),
        child: Text(title,style: TextStyle(color: AppColors.kWhiteColor),),
      ),
    );
  }

}
