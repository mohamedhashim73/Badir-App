import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/awesome_dialog_to_ask_visitor_to_login_first.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../../../Events/Presentation/Controller/events_cubit.dart';
import '../../../Events/Presentation/Screens/event_details_screen.dart';
import '../../../Events/Presentation/Screens/send_opinion_about_event_screen.dart';
import '../../Domain/Entities/user_entity.dart';
import '../Controller/layout_cubit.dart';

class EventItemOnHomeScreen extends StatelessWidget {
  final EventsCubit eventsCubit;
  final LayoutCubit layoutCubit;
  UserEntity? myData;
  final bool eventExpired;
  final EventEntity eventEntity;
  final BuildContext context;
  EventItemOnHomeScreen({Key? key,required this.context,required this.eventEntity,required this.layoutCubit,required this.eventsCubit,required this.eventExpired,this.myData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: بالنسبه لتلت متغيرات دول انا عامل if علي id بتاع المستخدم عشان اعرف اذا كان visitor ولا لا
    bool eventExpiredAndIHaveNotJoined = Constants.userID != null ? Constants.eventExpiredAndIHaveNotJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData!) : false;
    bool eventExpiredAndIHaveJoined = Constants.userID != null ? Constants.eventExpiredAndIHaveJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData!) : false ;
    bool eventInDateAndIHaveJoined = Constants.userID != null ? Constants.eventInDateAndIHaveJoined(event: eventEntity,eventExpired: eventExpired,userEntity: myData!) : false ;
    bool eventInDateAndIHaveNotJoinedYetAndHavePermission = Constants.userID != null ? Constants.eventInDateAndIHaveNotJoinedYetAndHavePermission(userEntity: myData!, eventExpired: eventExpired, event: eventEntity) : false ;
    bool eventInDateAndIDoNotHavePermissionToJoin = Constants.userID != null ? Constants.eventInDateAndIDoNotHavePermissionToJoin(userEntity: myData!, eventExpired: eventExpired, event: eventEntity) : false ;
    return InkWell(
      onTap: ()
      {
        if( Constants.userID != null )
          {
            bool eventFinished = DateTime.now().isAfter(Jiffy("${eventEntity.endDate!.trim()} ${eventEntity.time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime);
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventExpired: eventFinished)));
          }
        else
          {
            showDialogToVisitorToAskHimToLogin(context: context);
          }
      },
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
        decoration: BoxDecoration(
            color: AppColors.kMainColor,
            borderRadius: BorderRadius.circular(4.w)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text("# ${eventEntity.name}",style: TextStyle(color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 15.sp,height: 1.4),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Text(eventEntity.description!,style: TextStyle(color: AppColors.kWhiteColor,overflow:TextOverflow.ellipsis,fontWeight: FontWeight.w500,fontSize: 11.sp),maxLines: 3,),
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
                  if( Constants.userID == null )   // TODO: He is a Visitor
                    {
                      showDialogToVisitorToAskHimToLogin(context: context);
                    }
                  else
                    {
                      if ( myData!.idForClubLead != null )
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventExpired: false)));
                      }
                      else if( eventExpiredAndIHaveJoined )
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SendOpinionAboutEventScreen(eventName:eventEntity.name!,eventID:eventEntity.id!)));
                      }
                      else if( eventInDateAndIHaveNotJoinedYetAndHavePermission )
                      {
                        eventsCubit.joinToEvent(eventID: eventEntity.id!, layoutCubit: layoutCubit, memberID: myData!.id ?? Constants.userID!);
                      }
                      else if( eventInDateAndIHaveJoined )
                      {
                        showToastMessage(context: context, message: "لقد سبق لك التسجيل بالفعالية");
                      }
                      else if( eventInDateAndIDoNotHavePermissionToJoin )
                      {
                        showToastMessage(context: context, message: 'خاصة بأعضاء نادي ${eventEntity.clubName}',backgroundColor: AppColors.kRedColor);
                      }
                    }
                },
                // TODO: UserID == null => He is a Visitor ....
                color: Constants.userID == null ? AppColors.kWhiteColor : myData!.idForClubLead != null || eventInDateAndIHaveNotJoinedYetAndHavePermission ? AppColors.kWhiteColor : eventExpiredAndIHaveJoined ? AppColors.kOrangeColor : eventInDateAndIDoNotHavePermissionToJoin || eventExpiredAndIHaveNotJoined ? AppColors.kRedColor : AppColors.kGreenColor,
                textColor: Constants.userID == null ? AppColors.kBlackColor : myData!.idForClubLead != null || eventInDateAndIHaveNotJoinedYetAndHavePermission ? AppColors.kBlackColor : AppColors.kWhiteColor,
                child: Text(Constants.userID == null ? "إنضم إلينا" : myData!.idForClubLead != null ? "متابعة" : eventInDateAndIHaveJoined ? "تم التسجيل" :  eventInDateAndIHaveNotJoinedYetAndHavePermission ? "سجل الآن" : eventExpiredAndIHaveNotJoined ? "انتهت الفعالية" : eventInDateAndIDoNotHavePermissionToJoin ? "خاصة" : "شاركنا برأيك",style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

