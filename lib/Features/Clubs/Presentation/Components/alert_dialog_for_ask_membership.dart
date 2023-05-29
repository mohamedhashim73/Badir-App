import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Components/text_field_component.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Constants/constants.dart';
import '../Controller/clubs_states.dart';

void askMembershipDialog({required ClubEntity club,required BuildContext context,required ClubsCubit cubit,required TextEditingController controller,required UserEntity userEntity}){
  showDialog(context: context, builder: (context){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("طلب عضوية"),
        content: BlocBuilder<ClubsCubit,ClubsStates>(
          buildWhen: (previousState,currentState) => currentState is CommitteeChosenSuccessState,
          builder:(context,state)
          {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                [
                  Text("اللجنة",style: TextStyle(color: AppColors.kMainColor,fontWeight:FontWeight.bold,fontSize: 15.5.sp),),
                  SizedBox(height: 5.h),
                  dropDownComponent(
                      items: Constants.committees,
                      onChanged: (committeeChosen)
                      {
                        cubit.chooseCommittee(chosen: committeeChosen!);
                      },
                      value: cubit.selectedCommittee
                  ),
                  SizedBox(height: 5.h),
                  Text("تحدث عن نفسك",style: TextStyle(color: AppColors.kMainColor,fontWeight:FontWeight.bold,fontSize: 15.5.sp),),
                  SizedBox(height: 5.h),
                  textFieldComponent(controller: controller,maxLines: 4),
                  SizedBox(height: 7.h,),
                  Center(
                    child: DefaultButton(
                      title: state is SendRequestForMembershipLoadingState ? "جاري ارسال الطلب" : 'إرسال',
                      roundedRectangleBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                      ),
                      onTap: ()
                      {
                        if( cubit.selectedCommittee != null && controller.text.isNotEmpty && ( club.availableOnlyForThisCollege.isEmpty || ( club.availableOnlyForThisCollege.isNotEmpty && club.availableOnlyForThisCollege.contains(userEntity.college!) == true ) ) )
                        {
                          cubit.askForMembership(senderFirebaseFCMToken: userEntity.firebaseMessagingToken!,userEntity:userEntity,committeeName: cubit.selectedCommittee!,clubID: club.id.toString(), infoAboutAsker: controller.text, userName: userEntity.name!);
                        }
                        else if( cubit.selectedCommittee == null || controller.text.isEmpty )
                        {
                          showToastMessage(context: context, message: "برجاء ادخال المعلومات كاملة",backgroundColor: Colors.red);
                        }
                        else if( club.availableOnlyForThisCollege.isNotEmpty && club.availableOnlyForThisCollege.contains(userEntity.college!) == false )
                        {
                          Navigator.pop(context);  // TODO: Get out from alert dialog
                          showToastMessage(context: context, message: "غير مصرح لك بالإنضمام نظرا لعدم توفر الشروط !!",backgroundColor: Colors.red);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }
        )
      ),
    );
  });
}