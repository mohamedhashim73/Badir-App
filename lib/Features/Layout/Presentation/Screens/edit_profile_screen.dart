import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../../../Core/Components/text_field_component.dart';
import '../../../Auth/Presentation/Controller/auth_states.dart';

class EditProfileScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LayoutCubit.getInstance(context);
    _nameController.text = cubit.userData!.name!;
    _phoneController.text = cubit.userData!.phone.toString();
    cubit.selectedGender = cubit.userData!.gender!;
    cubit.selectedCollege = cubit.userData!.college!;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("تعديل البيانات"),
          ),
          body: BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state)
            {
              if( state is UpdateMyDataSuccessState )
              {
                showToastMessage(context: context, message: "تم تعديل البيانات بنجاح",backgroundColor: Colors.green,seconds: 2);
                _phoneController.clear();
                _nameController.clear();
                Navigator.pop(context);
              }
              if( state is RegisterFailedState )
              {
                showToastMessage(context: context, message: "حدث خطأ أثناء تعديلات البيانات برجاء المحاوله لاحقا",backgroundColor: Colors.red,seconds: 2);
              }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      _textUpperTextField(title: "الاسم"),
                      textFieldComponent(controller: _nameController),
                      _textUpperTextField(title: "رقم التليفون"),
                      textFieldComponent(controller: _phoneController),
                      _textUpperTextField(title: "الكية"),
                      dropDownComponent(
                          items: Constants.colleges,
                          onChanged: (college)
                          {
                            cubit.chooseCollege(college: college!);
                          },
                          value: cubit.selectedCollege
                      ),
                      _textUpperTextField(title: "الجنس"),
                      dropDownComponent(
                          items: Constants.genderStatus,
                          onChanged: (gender)
                          {
                            cubit.chooseGender(gender: gender!);
                          },
                          value: cubit.selectedGender
                      ),
                      SizedBox(height: 20.h,),
                      DefaultButton(
                        width: double.infinity,
                        onTap: ()
                        {
                          if( cubit.selectedGender != null && cubit.selectedCollege != null && _nameController.text.isNotEmpty && _phoneController.text.isNotEmpty )
                          {
                            cubit.updateMyData(
                                name: _nameController.text,
                                phone: int.parse(_phoneController.text),
                                gender: cubit.selectedGender!,
                                college: cubit.selectedCollege!
                            );
                          }
                          else
                          {
                            showToastMessage(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
                          }
                        },
                        title: state is UpdateMyDataLoadingState ? "جاري الحفظ" : "حفظ التعديلات",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _textUpperTextField({required String title}){
  return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp),)
  );
}




