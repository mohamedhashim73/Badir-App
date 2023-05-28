import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bader_user_app/Core/Constants/app_strings.dart';
import 'package:flutter/material.dart';

void showDialogToVisitorToAskHimToLogin({required BuildContext context}) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: "برجاء تسجيل الدخول أولا",
      btnOkText: "تسجيل الدخول",
      btnCancelText: "إلغاء",
      btnCancelOnPress: ()
      {
        Navigator.canPop(context) == true ? Navigator.pop(context) : Navigator.pushReplacementNamed(context, AppStrings.kHomeScreen);
      },
      btnOkOnPress: ()
      {
        Navigator.pushNamed(context, AppStrings.kLoginScreen);
      },
  )..show();
}