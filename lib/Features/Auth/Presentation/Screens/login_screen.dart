import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../Controller/auth_cubit.dart';
import '../Controller/auth_states.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginScreen({Key? key}) : super(key: key);

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
              if( state is LoginSuccessState )
              {
                showSnackBar(context: context, message: "تم تسجيل الدخول بنجاح",backgroundColor: Colors.green,seconds: 2);
                Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
              }
              if( state is LoginStateFailed )
              {
                showSnackBar(context: context, message: state.message,backgroundColor: Colors.red,seconds: 2);
              }
            },
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Center(
                      child: Text("تسجيل الدخول",style: TextStyle(fontWeight: FontWeight.bold,color:AppColors.kMainColor,fontSize: 20.sp),),
                    ),
                    SizedBox(height: 35.h,),
                    Text("البريد الإلكتروني",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 8.h,),
                    _textField(controller: _emailController,cubit: cubit,isSecure: false),
                    SizedBox(height: 13.h,),
                    Text("كلمة المرور",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 8.h,),
                    _textField(controller: _passwordController,isSecure: true,cubit: cubit),
                    SizedBox(height: 20.h,),
                    DefaultButton(
                      width: double.infinity,
                      onTap: ()
                      {
                        if( _emailController.text.isEmpty && _passwordController.text.isEmpty )
                          {
                            showSnackBar(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
                          }
                        else
                          {
                            cubit.login(email: _emailController.text, password: _passwordController.text);
                          }
                      },
                      title: "تسجيل",
                    ),
                    SizedBox(height: 7.5.h,),
                    Center(
                      child: GestureDetector(
                        child: Text("انشاء حساب",style: TextStyle(color: AppColors.kMainColor),),
                        onTap: ()
                        {
                          Navigator.pushNamed(context, AppStrings.kRegisterScreen);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _textField({required TextEditingController controller,required bool isSecure,required AuthCubit cubit}){
  return SizedBox(
    width: double.infinity,
    height: 45.h,
    child: TextFormField(
      controller: controller,
      obscureText: isSecure == false ? false : cubit.passwordShown ? false : true,
      decoration: InputDecoration(
        suffixIcon: isSecure == true ? GestureDetector(
          onTap: ()
          {
            cubit.changePasswordVisiblity();
          },
          child: Icon(cubit.passwordShown ? Icons.visibility : Icons.visibility_off),
        ) : const SizedBox(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4)
        ),
      ),
    ),
  );
}

