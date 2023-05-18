import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Screens/send_opinion_about_event_screen.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/button_item.dart';

class EventDetailsScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  final EventEntity event;
  final bool eventExpired;
  EventDetailsScreen({Key? key,required this.event,required this.eventExpired}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = event.name!;
    _descriptionController.text = event.description!;
    _startDateController.text = event.startDate!;
    _endDateController.text = event.endDate!;
    _locationController.text = event.location!;
    _linkController.text = event.link!;
    _timeController.text = event.time!;
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    final UserEntity userEntity = layoutCubit.userData!;
    final EventsCubit eventsCubit = EventsCubit.getInstance(context);
    bool eventExpiredAndIHaveNotJoined = Constants.eventExpiredAndIHaveNotJoined(event: event,eventExpired: eventExpired,userEntity: userEntity);
    bool eventExpiredAndIHaveJoined = Constants.eventExpiredAndIHaveJoined(event: event,eventExpired: eventExpired,userEntity: userEntity);
    bool eventInDateAndIHaveJoined = Constants.eventInDateAndIHaveJoined(event: event,eventExpired: eventExpired,userEntity: userEntity);
    bool eventInDateAndIHaveNotJoinedYetAndHavePermission = Constants.eventInDateAndIHaveNotJoinedYetAndHavePermission(userEntity: userEntity, eventExpired: eventExpired, event: event);
    bool eventInDateAndIDoNotHavePermissionToJoin = Constants.eventInDateAndIDoNotHavePermissionToJoin(userEntity: userEntity, eventExpired: eventExpired, event: event);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text("تفاضيل الفعالية"),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children:
              [
                CircleAvatar(
                  radius: 45.h,
                  backgroundImage: NetworkImage(event.image!),
                ),
                SizedBox(height: 12.5.h,),
                _textFieldItem(controller: _nameController,title:  'اسم الفعالية'),
                _textFieldItem(controller:_descriptionController,title: 'الوصف',maxLines: 3),
                _textFieldItem(controller:_startDateController,title: 'تاريخ البدء'),
                _textFieldItem(controller:_endDateController,title: 'تاريخ الانتهاء'),
                _textFieldItem(controller:_timeController,title: 'الوقت'),
                _textFieldItem(controller:_locationController,title: 'المكان'),
                _textFieldItem(controller:_linkController,title: 'اللينك'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Text("حالة الفعالية : ",style: TextStyle(color: AppColors.kMainColor,fontWeight: FontWeight.bold,fontSize: 15.5.sp),),
                    SizedBox(height: 3.h,),
                    Text(event.forPublic == EventForPublicOrNot.private.name ? 'خاصة بأعضاء ${event.clubName} فقط' : 'للمستخدمين جميعا',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.5.sp),),
                  ],
                ),
                if( userEntity.idForClubLead == null && ( eventInDateAndIHaveJoined || eventInDateAndIHaveNotJoinedYetAndHavePermission || eventExpiredAndIHaveJoined ) )
                  SizedBox(height: 10.h,),
                if( userEntity.idForClubLead == null && ( eventInDateAndIHaveJoined || eventInDateAndIHaveNotJoinedYetAndHavePermission || eventExpiredAndIHaveJoined ) )
                  DefaultButton(
                  // TODO: مش هيظهر الا اذا كنت مسجل فيها او هي كانت عامة بس لو انا ليدر مش هيظهر ...
                  width: double.infinity,
                  backgroundColor: eventExpiredAndIHaveJoined ? AppColors.kOrangeColor : eventInDateAndIHaveJoined ? AppColors.kGreenColor : AppColors.kMainColor,
                  onTap: ()
                  {
                    if( eventExpiredAndIHaveJoined )
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SendOpinionAboutEventScreen(eventName:event.name!,eventID:event.id!)));
                      }
                    else if( eventInDateAndIHaveNotJoinedYetAndHavePermission )
                      {
                        eventsCubit.joinToEvent(eventID: event.id!, layoutCubit: layoutCubit, memberID: userEntity.id ?? Constants.userID!);
                      }
                    else if( eventInDateAndIHaveJoined )
                      {
                        showSnackBar(context: context, message: "لقد سبق لك التسجيل بالفعالية",backgroundColor: AppColors.kRedColor);
                      }
                  },
                  title: eventExpiredAndIHaveJoined ? "شاركنا برأيك" : eventInDateAndIHaveJoined ? "تم التسجيل" : "سجل الآن",
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _textFieldItem({required TextEditingController controller,int? maxLines,required String title}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: TextFormField(
        enabled: false,
        controller: controller,
        maxLines: maxLines ?? 1,
        style: TextStyle(
            fontSize: 14.sp
        ),
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.kGreyColor,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            labelText: title,
            labelStyle: TextStyle(color: AppColors.kMainColor,fontSize: 16.sp,fontWeight: FontWeight.bold),
            border: const OutlineInputBorder()
        ),
      ),
    );
  }

}
