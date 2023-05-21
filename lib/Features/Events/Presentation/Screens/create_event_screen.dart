import 'package:bader_user_app/Core/Components/click_to_choose_file.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Constants/enumeration.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/snackBar_item.dart';
class CreateEventScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  CreateEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.getInstance(context);
    final clubsCubit = ClubsCubit.getInstance(context);
    final layoutCubit = LayoutCubit.getInstance(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('إنشاء فعالية'),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: BlocConsumer<EventsCubit,EventsStates>(
              listener: (context,state)
              {
                if( state is CreateEventSuccessState )
                {
                  Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
                  _nameController.clear();
                  _descriptionController.clear();
                  _startDateController.clear();
                  _endDateController.clear();
                  _timeController.clear();
                  _linkController.clear();
                  _locationController.clear();
                  cubit.eventImage = null;
                }
                if( state is FailedToCreateEventState )
                {
                  showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
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
                            if( cubit.eventImage != null )
                              Container(
                                height: 125.h,
                                width: 225.w,
                                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.black.withOpacity(0.4))
                                ),
                                child: GestureDetector(
                                    onTap: () => cubit.getEventImage(),
                                    child: Image.file(cubit.eventImage!,fit: BoxFit.fill,width: double.infinity,height: double.infinity,)),
                              ),
                            if( cubit.eventImage == null )
                              ClickToChooseFile(onTap : () => cubit.getEventImage(),text: "اضغط لاختيار صورة"),
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
                                  _radioItem(cubit: cubit, title: 'خاص بالنادي', value: EventForPublicOrNot.private),
                                  _radioItem(cubit: cubit, title: 'للعامة', value: EventForPublicOrNot.public),
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
                        if( cubit.eventImage == null )
                        {
                          showToastMessage(context: context, message: "برجاء اختيار صورة",backgroundColor: AppColors.kRedColor);
                        }
                        else if( cubit.eventImage != null && _timeController.text.isNotEmpty &&_nameController.text.isNotEmpty &&_descriptionController.text.isNotEmpty &&_endDateController.text.isNotEmpty &&_startDateController.text.isNotEmpty &&_linkController.text.isNotEmpty &&_locationController.text.isNotEmpty)
                        {
                          cubit.createEvent(layoutCubit: layoutCubit, forPublic: cubit.eventForPublic, name: _nameController.text, description: _descriptionController.text, startDate: _startDateController.text, endDate: _endDateController.text, time: _timeController.text, location: _locationController.text, link: _linkController.text, clubID: clubsCubit.dataAboutClubYouLead!.id.toString(), clubName: clubsCubit.dataAboutClubYouLead!.name!);
                        }
                        else
                        {
                          showToastMessage(context: context, message: "من فضلك قم بإدخال البيانات كاملة",backgroundColor: AppColors.kRedColor);
                        }
                      },
                      title: state is CreateEventLoadingState ? "جاري الإنشاء" : "إنشاء",
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
