import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/click_to_choose_file.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/app_strings.dart';

class UploadReportToAdminScreen extends StatelessWidget {
  const UploadReportToAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    ClubEntity club = ClubsCubit.getInstance(context).dataAboutClubYouLead!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("رفع التقارير"),),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
            child: BlocConsumer<LayoutCubit,LayoutStates>(
              listener: (context,state)
              {
                if( state is UploadReportToAdminLoadingState ) showLoadingDialog(context: context);
                if( state is UploadReportToAdminSuccessState )
                {
                  Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                  Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
                  layoutCubit.reportType = null;
                  layoutCubit.pdfFile = null;
                }
                if( state is UploadReportToAdminWithFailureState )
                {
                  Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                  showToastMessage(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                }
              },
              builder: (context,state){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Container(
                      margin: EdgeInsets.only(bottom: 7.h),
                      child: Text("نوع التقرير",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),)
                      ),
                    dropDownComponent(
                        items: Constants.reportTypes,
                        onChanged: (reportType)
                        {
                          layoutCubit.chooseReportType(chosen: reportType!);
                        },
                        value: layoutCubit.reportType
                    ),
                    SizedBox(height: 10.h,),
                    if( layoutCubit.pdfFile != null )
                      InkWell(
                        onTap: () => layoutCubit.getPDF(),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                            child: Row(
                              children:
                              [
                                Icon(Icons.picture_as_pdf,color: AppColors.kRedColor,),
                                SizedBox(width: 7.5.w,),
                                Expanded(child: Text(basename(layoutCubit.pdfFile!.path),style: const TextStyle(overflow: TextOverflow.ellipsis),))
                              ],
                            ),
                          ),
                        ),
                      ),
                    if( layoutCubit.pdfFile == null )
                      ClickToChooseFile(onTap : () => layoutCubit.getPDF(),text: "اضغط لاختيار ملف"),
                    SizedBox(height: 15.h,),
                    DefaultButton(
                      width: double.infinity,
                      onTap: ()
                      {
                        if( layoutCubit.reportType != null && layoutCubit.pdfFile != null )
                        {
                          layoutCubit.uploadReport(clubName:club.name!,senderID:layoutCubit.userData!.id ?? Constants.userID!,reportType: layoutCubit.reportType!,clubID: club.id.toString(),layoutCubit: layoutCubit);
                        }
                        else
                        {
                          showToastMessage(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
                        }
                      },
                      title: "إرسال"
                    ),
                  ],
                );
              }
            ),
        ),
        )
      ),
    );
  }
}
