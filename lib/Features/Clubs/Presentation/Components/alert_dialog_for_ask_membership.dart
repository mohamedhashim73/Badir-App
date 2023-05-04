import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Components/text_field_component.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Constants/constants.dart';
import '../Controller/clubs_states.dart';

void askMembershipDialog({required BuildContext context,required ClubsCubit cubit,required TextEditingController controller,required String clubID,required String requestUserName,required String? committeeName}){
  showDialog(context: context, builder: (context){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("طلب عضوية"),
        content: BlocBuilder<ClubsCubit,ClubsStates>(
          buildWhen: (previousState,currentState) => currentState is CommitteeChosenSuccessState,
          builder:(context,state)
          {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                const Text("اللجنة"),
                SizedBox(height: 5.h),
                dropDownComponent(
                    items: Constants.committees,
                    onChanged: (committeeChosen)
                    {
                      cubit.chooseCommittee(chosen: committeeChosen!);
                    },
                    value: cubit.selectedCommittee
                ),
                const Text("تحدث عن نفسك"),
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
                      debugPrint("Committee is : ${cubit.selectedCommittee}");
                      if( cubit.selectedCommittee == null || controller.text.isEmpty )
                      {
                        showSnackBar(context: context, message: "برجاء ادخال المعلومات كاملة",backgroundColor: Colors.red);
                      }
                      else
                      {
                        cubit.askForMembership(clubID: clubID, infoAboutAsker: controller.text,userName: requestUserName);
                      }
                    },
                  ),
                )
              ],
            );
          }
        )
      ),
    );
  });
}