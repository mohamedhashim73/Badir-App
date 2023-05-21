import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../Layout/Domain/Entities/user_entity.dart';
import '../../../Layout/Presentation/Controller/layout_cubit.dart';
import '../../Data/Models/opinion_about_event_model.dart';
import '../Controller/events_cubit.dart';
import '../Controller/events_states.dart';
class SendOpinionAboutEventScreen extends StatelessWidget {
  final String eventID;
  final String eventName;
  final TextEditingController controller = TextEditingController();
  SendOpinionAboutEventScreen({Key? key,required this.eventID,required this.eventName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserEntity userEntity = LayoutCubit.getInstance(context).userData!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("شاركنا برأيك"),),
          body: BlocListener<EventsCubit,EventsStates>(
            listener: (context,state)
            {
              if( state is SendOpinionAboutEventLoadingState ) showLoadingDialog(context:context);
              if( state is FailedToSendOpinionAboutEventState )
                {
                  Navigator.pop(context); // TODO: Get out from Alert Dialog
                  Navigator.pop(context);
                  showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                }
              if( state is SendOpinionAboutEventSuccessState )
                {
                  Navigator.pop(context); // TODO: Get out from Alert Dialog
                  Navigator.pop(context);
                  showToastMessage(context: context, message: 'تم إرسال رأيك بنجاح');
                }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    Text("رأيك مسموع ويهمنا !!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.5.sp,color: AppColors.kYellowColor),),
                    SizedBox(height: 20.h,),
                    Card(
                      child: TextField(
                        maxLines: 12,
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12.5.h,horizontal: 12.w)
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    MaterialButton(
                      onPressed: ()
                      {
                        OpinionAboutEventModel opinion = OpinionAboutEventModel(controller.text, userEntity.name!, eventName);
                        EventsCubit.getInstance(context).sendOpinionAboutEvent(eventID: eventID, opinionModel: opinion, senderID: userEntity.id!);
                      },
                      elevation: 0,
                      textColor: AppColors.kWhiteColor,
                      color: AppColors.kMainColor,
                      height: 35.h,
                      minWidth: 120.w,
                      child: Text("إرسال",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
