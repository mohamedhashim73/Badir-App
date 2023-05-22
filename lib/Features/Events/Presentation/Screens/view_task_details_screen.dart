import 'package:bader_user_app/Core/Components/text_field_component.dart';
import 'package:bader_user_app/Core/Components/text_upper_textformfield.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../Domain/Entities/task_entity.dart';

class ViewTaskDetailsScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numOfPositionsController = TextEditingController();
  final TextEditingController _numOfRegisteredController = TextEditingController();
  final TextEditingController _numOfHoursController = TextEditingController();
  final TaskEntity taskEntity;
  ViewTaskDetailsScreen({Key? key,required this.taskEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = taskEntity.name;
    _descriptionController.text = taskEntity.name;
    _numOfPositionsController.text = taskEntity.numOfPosition.toString();
    _numOfRegisteredController.text = taskEntity.numOfRegistered.toString();
    _numOfHoursController.text = taskEntity.hours.toString();
    _eventName.text = taskEntity.forPublicOrSpecificToAnEvent ? "غير خاص بفعالية معينه" : taskEntity.eventName!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text("تفاصيل المهمة"),),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:
                [
                  _textFieldItem(controller: _nameController,labelText: 'اسم المهمة'),
                  _textFieldItem(controller: _eventName,labelText: 'اسم الفعالية'),
                  _textFieldItem(maxLines:5,controller: _descriptionController,labelText: 'وصف المهمة'),
                  _textFieldItem(controller: _numOfHoursController,labelText: 'عدد الساعات'),
                  _textFieldItem(controller: _numOfRegisteredController,labelText: 'عدد المسجلين'),
                  _textFieldItem(controller: _numOfPositionsController,labelText: 'عدد الأشخاص'),
                ],
              )
            ),
          )
      ),
    );
  }

  Widget _textFieldItem({required TextEditingController controller,int? maxLines,required String labelText}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: TextFormField(
        enabled: false,
        controller: controller,
        maxLines: maxLines ?? 1,
        style: TextStyle(
            fontSize: 14.sp,color: AppColors.kBlackColor.withOpacity(0.8)
        ),
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.kGreyColor,
            contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 8.w),
            labelText: labelText,
            labelStyle: TextStyle(color: AppColors.kMainColor,fontSize: 16.sp,fontWeight: FontWeight.bold),
            border: const OutlineInputBorder()
        ),
      ),
    );
  }

}
