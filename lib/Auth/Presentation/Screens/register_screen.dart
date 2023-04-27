import 'package:bader_user_app/Auth/Presentation/Controller/auth_cubit.dart';
import 'package:bader_user_app/Auth/Presentation/Controller/auth_states.dart';
import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Components/drop_down_items.dart';
import '../../../Core/Components/snackBar_item.dart';
import '../../../Core/Components/text_field_component.dart';
import '../../../Core/Theme/app_colors.dart';
import '../../../Core/Utils/app_strings.dart';

class RegisterScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.getInstance(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocConsumer<AuthCubit,AuthStates>(
            listener: (context,state)
            {
              if( state is RegisterSuccessState )
              {
                showSnackBar(context: context, message: "تم انشاء الحساب بنجاح",backgroundColor: Colors.green,seconds: 2);
                _emailController.clear();
                _passwordController.clear();
                _phoneController.clear();
                _nameController.clear();
                Navigator.pushNamed(context, AppStrings.kLoginScreen);
              }
              if( state is RegisterFailedState )
              {
                showSnackBar(context: context, message: state.message,backgroundColor: Colors.red,seconds: 2);
              }
            },
            builder: (context,state) {
              return Center(
                child: Padding(
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
                        _textUpperTextField(title: "البريد الإلكتروني"),
                        textFieldComponent(controller: _emailController),
                        _textUpperTextField(title: "كلمة المرور"),
                        textFieldComponent(controller: _passwordController, isSecure: true),
                        SizedBox(height: 20.h,),
                        DefaultButton(
                          width: double.infinity,
                          onTap: ()
                          {
                            if( _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && cubit.selectedGender != null && cubit.selectedCollege != null && _nameController.text.isNotEmpty && _phoneController.text.isNotEmpty )
                            {
                              cubit.register(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: int.parse(_phoneController.text),
                                  password: _passwordController.text,
                                  gender: cubit.selectedGender!,
                                  college: cubit.selectedCollege!
                              );
                            }
                            else
                            {
                              showSnackBar(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
                            }
                          },
                          title: state is RegisterLoadingState ? "جاري انشاء الحساب" : "انشاء حساب",
                        ),
                        SizedBox(height: 7.5.h,),
                        Center(
                          child: GestureDetector(
                            child: Text("تسجيل الدخول",style: TextStyle(color: AppColors.kMainColor),),
                            onTap: ()
                            {
                              Navigator.pushNamed(context, AppStrings.kLoginScreen);
                            },
                          ),
                        )
                      ],
                    ),
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
      child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),)
  );
}

