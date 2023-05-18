import 'package:bader_user_app/Core/Components/alert_dialog_for_loading_item.dart';
import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateClubAvailabilityScreen extends StatelessWidget {
  const UpdateClubAvailabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    final ClubEntity clubEntity = clubsCubit.dataAboutClubYouLead!;
    clubsCubit.clubAvailabilityStatus = clubEntity.isAvailable;
    clubsCubit.selectedColleges = (clubEntity.availableOnlyForThisCollege).cast<String>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("التسجيل بالنادي"),),
            body: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 60.h),
                child: BlocConsumer<ClubsCubit,ClubsStates>(
                    buildWhen: (pastState,currentState) => currentState is AddOrRemoveOptionToSelectedCollegesState || currentState is ChangeClubAvailabilityStatusState,
                    listener: (context,state)
                    {
                      if( state is UpdateClubAvailabilityLoadingState ) showLoadingDialog(context: context);
                      if( state is UpdateClubAvailabilitySuccessState )
                      {
                        Navigator.pop(context);     // TODO: Get out from Alert Dialog
                        showSnackBar(context: context, message: "تم تعديل بيانات النادي");
                        Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
                      }
                    },
                    builder: (context,state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          SwitchListTile(
                              title: Text("الإنضمام للنادي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold,color: AppColors.kRedColor),),
                              value: clubsCubit.clubAvailabilityStatus,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val)
                              {
                                clubsCubit.changeClubAvailabilityStatus(status: val);
                              }
                          ),
                          SizedBox(height: 7.h,),
                          Text("السماح بلإنضمام لأصحاب الكليات الآتية",style: TextStyle(overflow:TextOverflow.ellipsis,fontSize: 15.sp,fontWeight: FontWeight.bold,color: AppColors.kMainColor),),
                          Expanded(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: Constants.colleges.map((chosenCollege) => CheckboxListTile(
                                  title: Text(chosenCollege),
                                  value: clubsCubit.selectedColleges.contains(chosenCollege),
                                  onChanged: (value)
                                  {
                                    clubsCubit.addOrRemoveOptionToSelectedColleges(status: value!, college: chosenCollege);
                                  },
                                )).toList(),
                              )
                          ),
                          SizedBox(height: 20.h,),
                          Center(
                            child: MaterialButton(
                                height: 35.h,
                                minWidth: 100.w,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onPressed: ()
                                {
                                  if( clubsCubit.selectedColleges.isNotEmpty )
                                  {
                                    clubsCubit.updateClubAvailability(clubID: clubEntity.id.toString(), isAvailable: clubsCubit.clubAvailabilityStatus, availableOnlyForThisCollege: clubsCubit.selectedColleges);
                                  }
                                  else if( clubsCubit.selectedColleges.isEmpty )
                                  {
                                    showSnackBar(context: context, message: 'برجاء إدخال البيانات كاملة، ثم أعد مرة ثانيه',backgroundColor: AppColors.kRedColor);
                                  }
                                },
                                color: AppColors.kMainColor,
                                textColor: AppColors.kWhiteColor,
                                child: Text("إرسال",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.5.sp),)
                            ),
                          )
                        ],
                      );
                    }
                )
            ),
          )
      ),
    );
  }
}
