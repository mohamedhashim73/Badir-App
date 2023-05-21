import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/snackBar_item.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final MeetingEntity meetingEntity;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  MeetingDetailsScreen({Key? key,required this.meetingEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = meetingEntity.name!;
    _descriptionController.text = meetingEntity.description!;
    _dateController.text = meetingEntity.date!;
    _timeController.text = meetingEntity.time!;
    _locationController.text = meetingEntity.location!;
    _linkController.text = meetingEntity.link!;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تفاصيل الإجتماع'),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: BlocListener<LayoutCubit,LayoutStates>(
              listener: (context,state)
              {
                if( state is ErrorDuringOpenPdfState ) showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
              },
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:
                [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        _textFieldItem(controller: _nameController,title:  'اسم الاجتماع'),
                        _textFieldItem(controller:_descriptionController,title: 'الوصف',maxLines: 3),
                        _textFieldItem(controller:_dateController,title: 'التاريخ'),
                        _textFieldItem(controller:_timeController,title: 'الوقت'),
                        _textFieldItem(controller:_locationController,title: 'المكان'),
                        _textFieldItem(controller:_linkController,title: 'الرابط'),
                        SizedBox(height: 10.h,),
                        DefaultButton(
                          width: double.infinity,
                          onTap: ()
                          {
                            LayoutCubit.getInstance(context).openPdf(link: meetingEntity.link!);
                          },
                          title: "فتح الرابط",
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
