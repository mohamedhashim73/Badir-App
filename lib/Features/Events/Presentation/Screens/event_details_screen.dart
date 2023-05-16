import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
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
  final bool eventDateExpired;
  EventDetailsScreen({Key? key,required this.event,required this.eventDateExpired}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = event.name!;
    _descriptionController.text = event.description!;
    _startDateController.text = event.startDate!;
    _endDateController.text = event.endDate!;
    _locationController.text = event.location!;
    _linkController.text = event.link!;
    _timeController.text = event.time!;
    final UserEntity userEntity = LayoutCubit.getInstance(context).userData!;
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
                _textField(itemsRepresentOnRowNotColumn:false,controller: _nameController,title:  'اسم الفعالية'),
                _textField(itemsRepresentOnRowNotColumn:false,controller:_descriptionController,title: 'الوصف'),
                _textField(controller:_startDateController,title: 'تاريخ البداية',onTap: () async => _startDateController.text = Jiffy(await Constants.selectDate(context: context)).yMMMd),
                _textField(controller:_endDateController,title: 'تاريخ الانتهاء',onTap: () async => _endDateController.text = Jiffy(await Constants.selectDate(context: context)).yMMMd),
                _textField(controller:_timeController,title: 'الوقت',onTap: (){}),
                _textField(controller:_locationController,title: 'المكان'),
                _textField(controller:_linkController,title: 'اللينك'),
                _radioItem(title: 'خاص بالنادي', value: EventForPublicOrNot.private),
                if( userEntity.idForClubLead == null && ( ( userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(event.id) ) || event.forPublic == EventForPublicOrNot.public.name ) )
                  SizedBox(height: 10.h,),
                if( userEntity.idForClubLead == null && ( ( userEntity.idForEventsJoined != null && userEntity.idForEventsJoined!.contains(event.id) ) || event.forPublic == EventForPublicOrNot.public.name ) )
                  DefaultButton(
                  // TODO: مش هيظهر الا اذا كنت مسجل فيها او هي كانت عامة بس لو انا ليدر مش هيظهر ...
                  width: double.infinity,
                  onTap: ()
                  {
                    if( eventDateExpired )
                      {
                        // TODO: Give opinion ....
                      }
                    else
                      {
                        // TODO: Ask to join to it ....
                      }
                  },
                  title: eventDateExpired ? "شاركنا برأيك!" : "انضمام",
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _textField({bool itemsRepresentOnRowNotColumn = true ,Function()? onTap,required TextEditingController controller, required String title, TextInputType? textInputType}){
    return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
        decoration: BoxDecoration(
            color: AppColors.kYellowColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.kMainColor),
        ),
        child: itemsRepresentOnRowNotColumn == false ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(title,style: TextStyle(color:AppColors.kRedColor,fontWeight: FontWeight.bold,fontSize: 16.sp),),
            Text(controller.text)
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Text(title,style: TextStyle(color:AppColors.kRedColor,fontWeight: FontWeight.bold,fontSize: 16.sp),),
            Expanded(child: Text(controller.text,textAlign: TextAlign.left,style: const TextStyle(overflow: TextOverflow.ellipsis),))
          ],
        )
    );
  }

  Widget _radioItem({required String title,required EventForPublicOrNot value,}){
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      toggleable: true,
      selected: true,
      activeColor: AppColors.kRedColor,
      groupValue: "",
      onChanged: (Object? value) {  },
    );
  }

}
