import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifyComponent extends StatelessWidget {
  final NotificationEntity notifyData;
  const NotifyComponent({Key? key,required this.notifyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.kYellowColor
      ),
      child: Column(
        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
            [
              Icon(Icons.notifications,color: AppColors.kMainColor,),
              SizedBox(width: 7.w,),
              Expanded(
                child: Text(notifyData.notifyMessage!),
              ),

            ],
          ),
          SizedBox(height: 2.5.h,),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Text(notifyData.receiveDate!),
          )
        ],
      ),
    );
  }
}
