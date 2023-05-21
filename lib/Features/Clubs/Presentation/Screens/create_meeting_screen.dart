import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/snackBar_item.dart';

class CreateMeetingScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  CreateMeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clubsCubit = ClubsCubit.getInstance(context);
    final clubID = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('إنشاء إجتماع'),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: BlocConsumer<ClubsCubit,ClubsStates>(
              listener: (context,state)
              {
                if( state is CreateMeetingLoadingState ) showLoadingDialog(context: context);
                if( state is CreateMeetingSuccessState )
                {
                  Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                  Navigator.pop(context);   // TODO: Back to last screen
                  _nameController.clear();
                  _descriptionController.clear();
                  _dateController.clear();
                  _timeController.clear();
                  _linkController.clear();
                  _locationController.clear();
                }
                if( state is CreateMeetingWithFailureState )
                {
                  Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                  showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                }
              },
              builder: (context,state) {
                return ListView(
                  children:
                  [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          _textField(controller: _nameController,title:  'اسم الاجتماع'),
                          _textField(controller:_descriptionController,title: 'الوصف'),
                          _textField(controller:_dateController,title: 'التاريخ',onTap: () async => _dateController.text = Jiffy(await Constants.selectDate(context: context)).yMMMd),
                          _textField(controller:_timeController,title: 'الوقت',onTap: () async {
                            TimeOfDay? timeNow = await Constants.selectTime(context: context);
                            _timeController.text = Jiffy({
                              'hour': timeNow!.hour,
                              'minute': timeNow.minute,
                            }).format('h:mm a');
                          }),
                          _textField(controller:_locationController,title: 'المكان'),
                          _textField(controller:_linkController,title: 'الرابط'),
                          SizedBox(height: 7.h,),
                          DefaultButton(
                            width: double.infinity,
                            onTap: ()
                            {
                              if( _timeController.text.isNotEmpty &&_nameController.text.isNotEmpty &&_descriptionController.text.isNotEmpty &&_dateController.text.isNotEmpty &&_linkController.text.isNotEmpty &&_locationController.text.isNotEmpty)
                              {
                                clubsCubit.createMeeting(idForClubILead: clubID,name: _nameController.text, description: _descriptionController.text, date: _dateController.text,time: _timeController.text, location: _locationController.text, link: _linkController.text);
                              }
                              else
                              {
                                showToastMessage(context: context, message: "من فضلك قم بإدخال البيانات كاملة",backgroundColor: AppColors.kRedColor);
                              }
                            },
                            title: "إنشاء",
                          )
                        ],
                      ),
                    ),
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

}
