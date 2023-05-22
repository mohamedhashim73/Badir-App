import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/meeting_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/snackBar_item.dart';

class DisplayMemberDataScreen extends StatelessWidget {
  final UserEntity userEntity;
  final _nameController = TextEditingController();
  final _volunteerHoursController = TextEditingController();
  final _phoneController = TextEditingController();
  final _collegeController = TextEditingController();
  final _emailController = TextEditingController();
  DisplayMemberDataScreen({Key? key,required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClubsCubit.getInstance(context).getDataAboutSpecificMember(memberID: userEntity.id!);
    _nameController.text = userEntity.name!;
    _volunteerHoursController.text = userEntity.volunteerHours != null ? userEntity.volunteerHours.toString() : 0.toString();
    _phoneController.text = userEntity.phone.toString();
    _collegeController.text = userEntity.college!;
    _emailController.text = userEntity.email!;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تفاصيل العضو'),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: 12.w),
            child: BlocConsumer<ClubsCubit,ClubsStates>(
              listener: (context,state) {},
              builder: (context,state) {
                return state is GetMemberDataSuccessState ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      _textFieldItem(controller: _nameController,title:  'اسم العضو'),
                      _textFieldItem(controller:_collegeController,title: 'الكلية'),
                      _textFieldItem(controller:_volunteerHoursController,title: 'عدد الساعات التطوعية'),
                      _textFieldItem(controller:_emailController,title: 'البريد الإلكتروني'),
                      _textFieldItem(controller:_phoneController,title: 'رقم التليفون'),
                    ],
                  ),
                ) : state is GetMemberDataWithFailureState ? Center(
                  child: Text(state.message,style: TextStyle(color: Colors.grey,fontSize: 15.sp),),
                ) : const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ),
        ),
      ),
    );
  }

  Widget _textFieldItem({required TextEditingController controller,required String title}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: TextFormField(
        enabled: false,
        controller: controller,
        style: TextStyle(
            fontSize: 14.sp,color: AppColors.kBlackColor.withOpacity(0.8)
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
