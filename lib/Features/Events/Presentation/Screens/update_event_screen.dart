import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Components/click_to_choose_file.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Events/Domain/Entities/event_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/snackBar_item.dart';

class UpdateEventScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  final EventEntity eventEntity;
  UpdateEventScreen({Key? key,required this.eventEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsCubit eventsCubit = EventsCubit.getInstance(context);
    final LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    final String idForClubILead = layoutCubit.userData!.idForClubLead!;
    _nameController.text = eventEntity.name!;
    _descriptionController.text = eventEntity.description!;
    _startDateController.text = eventEntity.startDate!;
    _endDateController.text = eventEntity.endDate!;
    _timeController.text = eventEntity.time!;
    _locationController.text = eventEntity.location!;
    _linkController.text = eventEntity.link!;
    eventsCubit.eventForPublic = eventEntity.forPublic == EventForPublicOrNot.public.name ? EventForPublicOrNot.public : EventForPublicOrNot.private;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تعديل بيانات الفعالية'),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: BlocConsumer<EventsCubit,EventsStates>(
              listener: (context,state)
              {
                if( state is UpdateEventLoadingState ) showLoadingDialog(context: context);
                if( state is UpdateEventSuccessState )
                {
                  Navigator.pop(context);
                  _nameController.clear();
                  _descriptionController.clear();
                  _startDateController.clear();
                  _endDateController.clear();
                  _timeController.clear();
                  _linkController.clear();
                  _locationController.clear();
                  eventsCubit.eventImage = null;
                  eventsCubit.eventForPublic = EventForPublicOrNot.public;
                  Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
                }
                if( state is FailedToUpdateEventState )
                {
                  Navigator.pop(context);
                  showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                }
              },
              builder: (context,state) {
                return Column(
                  children:
                  [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Container(
                                height: 125.h,
                                width: 225.w,
                                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.black.withOpacity(0.4))
                                ),
                                child: GestureDetector(
                                    onTap: () => eventsCubit.getEventImage(),
                                    child: eventsCubit.eventImage != null ? Image.file(eventsCubit.eventImage!,fit: BoxFit.fill,width: double.infinity,height: double.infinity,) : Image.network(eventEntity.image!,fit: BoxFit.fill,width: double.infinity,height: double.infinity,)),
                              ),
                            SizedBox(height: 12.5.h,),
                            _textField(controller: _nameController,title:  'اسم الفعالية'),
                            _textField(controller:_descriptionController,title: 'الوصف'),
                            _textField(controller:_startDateController,title: 'تاريخ البداية',onTap: () async => _startDateController.text = Jiffy(await Constants.selectDate(context: context)).yMMMd),
                            _textField(controller:_endDateController,title: 'تاريخ الانتهاء',onTap: () async => _endDateController.text = Jiffy(await Constants.selectDate(context: context)).yMMMd),
                            _textField(controller:_timeController,title: 'الوقت',onTap: () async {
                              TimeOfDay? timeNow = await Constants.selectTime(context: context);
                              _timeController.text = Jiffy({
                                'hour': timeNow!.hour,
                                'minute': timeNow.minute,
                              }).format('h:mm a');
                            }),
                            _textField(controller:_locationController,title: 'المكان'),
                            _textField(controller:_linkController,title: 'اللينك'),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children:
                                [
                                  _radioItem(cubit: eventsCubit, title: 'خاص بالنادي', value: EventForPublicOrNot.private),
                                  _radioItem(cubit: eventsCubit, title: 'للعامة', value: EventForPublicOrNot.public),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    DefaultButton(
                      width: double.infinity,
                      onTap: ()
                      {
                        if( _timeController.text.isNotEmpty &&_nameController.text.isNotEmpty &&_descriptionController.text.isNotEmpty &&_endDateController.text.isNotEmpty &&_startDateController.text.isNotEmpty &&_linkController.text.isNotEmpty &&_locationController.text.isNotEmpty)
                        {
                          eventsCubit.updateEvent(layoutCubit: layoutCubit, mainImageUrl: eventEntity.image!, eventID: eventEntity.id!, name: _nameController.text, forPublic: eventsCubit.eventForPublic, description: _descriptionController.text, startDate: _startDateController.text, endDate: _endDateController.text, time: _timeController.text, location: _locationController.text, link: _linkController.text, clubID: eventEntity.clubID!, clubName: eventEntity.clubName!);
                        }
                        else
                        {
                          showSnackBar(context: context, message: "من فضلك قم بإدخال البيانات كاملة",backgroundColor: AppColors.kRedColor);
                        }
                      },
                      title: "تعديل",
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({Function()? onTap,required TextEditingController controller, required String title, TextInputType? textInputType}){
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: TextField(
        controller: controller,
        onTap: onTap,
        keyboardType: textInputType ?? TextInputType.name,
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.kPinkColor,
            labelText: title,
            border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.kMainColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.kMainColor))
        ),
      ),
    );
  }

  Widget _radioItem({required EventsCubit cubit,required String title,required EventForPublicOrNot value,}){
    return Expanded(
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          value: value,
          toggleable: true,
          selected: cubit.eventForPublic == value ? true : false,
          activeColor: cubit.eventForPublic == value ? AppColors.kRedColor : Colors.black.withOpacity(0.5),
          groupValue: "EventForPublicOrNot",
          onChanged: (val)
          {
            debugPrint("Event For public or not is : $val");
            cubit.chooseEventForPublicOrNot(value: value);
          },
        )
    );
  }

}
