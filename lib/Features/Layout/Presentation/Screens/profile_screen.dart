import 'package:bader_user_app/Core/Components/drwaer_item.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/Layout_Cubit/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/Layout_Cubit/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Theme/app_colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LayoutCubit.getInstance(context);
    if(cubit.userData == null ) cubit.getMyData();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: DrawerItem(),
          appBar: AppBar(
              title: const Text("الملف الشخصي")
          ),
          body: BlocConsumer<LayoutCubit,LayoutStates>(
                buildWhen: (lastState,currentState)
                {
                  return currentState is GetMyDataSuccessState;
                },
                listener: (context,state)
                {

                },
                builder: (context,state) {
                  return cubit.userData != null ?
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 30.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children:
                          [
                            Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.kYellowColor,
                                  radius: 35.w,
                                ),
                                CircleAvatar(
                                  radius: 12.5.w,
                                  backgroundColor: Colors.grey,
                                  child: GestureDetector(
                                    onTap: ()
                                    {
                                      Navigator.pushNamed(context, AppStrings.kEditProfileScreen);
                                    },
                                    child: Icon(Icons.edit,color: Colors.white,size: 15.w,),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Text(cubit.userData!.name!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),),
                            SizedBox(height: 20.h,),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 15.w),
                              decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(0.1),
                              ),
                              child: Column(
                                children:
                                [
                                  _titleBehindDescriptionItem(title: "البريد الإلكتروني", description: cubit.userData!.email!),
                                  SizedBox(height: 2.h,),
                                  _titleBehindDescriptionItem(title: "رقم الهاتف", description: cubit.userData!.phone.toString()),
                                  SizedBox(height: 2.h,),
                                  _titleBehindDescriptionItem(title: "الجنس", description: cubit.userData!.gender!),
                                  SizedBox(height: 2.h,),
                                  _titleBehindDescriptionItem(title: "الكلية", description: cubit.userData!.college!),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            // TODO: This Will be show if he is a member on any club
                            if( cubit.userData!.committeeName!.isNotEmpty )
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(0.1),
                                ),
                                child: Column(
                                  children:
                                  [
                                    _titleBehindDescriptionItem(title: "اللجنة", description: "العلمية"),
                                    SizedBox(height: 2.h,),
                                    _titleBehindDescriptionItem(title: "الساعات التطوعية", description: "100 ساعة"),
                                    SizedBox(height: 2.h,),
                                    _titleBehindDescriptionItem(title: "بداية العضوية", description: "10/10/2024"),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ) :
                    Center(
                      child: CircularProgressIndicator(color: AppColors.kMainColor,),
                    );
                }
              )
        ),
      ),
    );
  }

  Widget _titleBehindDescriptionItem({required String title,required String description}){
    return Row(
      children:
      [
        Text("$title :"),
        SizedBox(width: 2.5.w,),
        Expanded(child: Text(description)),
      ],
    );
  }
}
