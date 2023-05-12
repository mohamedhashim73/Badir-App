import 'package:bader_user_app/Core/Theme/app_colors.dart';
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
import '../../../../Core/Utils/app_strings.dart';

class UploadReportToAdminScreen extends StatelessWidget {
  const UploadReportToAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = LayoutCubit.getInstance(context);
    String clubID = layoutCubit.userData!.idForClubLead!;
    return SafeArea(
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
                layoutCubit.reportType = null;
                layoutCubit.pdfFile = null;
                Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                Navigator.pushReplacementNamed(context, AppStrings.kLayoutScreen);
              }
              if( state is UploadReportToAdminWithFailureState )
              {
                Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
              }
            },
            builder: (context,state){
              return Column(
                children:
                [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.h),
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
                  if( layoutCubit.pdfFile != null )
                    Card(
                      child: Row(
                        children:
                        [
                          Icon(Icons.picture_as_pdf,color: AppColors.kRedColor,),
                          SizedBox(width: 7.5.w,),
                          Expanded(child: Text(basename(layoutCubit.pdfFile!.path),style: const TextStyle(overflow: TextOverflow.ellipsis),))
                        ],
                      ),
                    ),
                  if( layoutCubit.pdfFile == null )
                    ClickToChooseFile(onTap : () => layoutCubit.getPDF(),text: "اضغط لاختيار ملف"),
                  SizedBox(height: 10.h,),
                  DefaultButton(
                    width: double.infinity,
                    onTap: ()
                    {
                      if( layoutCubit.reportType != null && layoutCubit.pdfFile != null )
                      {
                        layoutCubit.uploadReport(reportType: layoutCubit.reportType!,clubID: clubID,layoutCubit: layoutCubit);
                      }
                      else
                      {
                        showSnackBar(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
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
    );
  }
}
