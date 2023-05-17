import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/text_field_component.dart';
import '../../../../Core/Constants/app_strings.dart';

class UpdateClubScreen extends StatelessWidget {
  final _twitterController = TextEditingController();
  final _collegeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _membersNumController = TextEditingController();
  final _aboutClubController = TextEditingController();
  UpdateClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String clubID = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    final cubit = ClubsCubit.getInstance(context)..getCLubDataThatILead(clubID: clubID);
    _nameController.text = cubit.dataAboutClubYouLead!.name!;
    _collegeController.text = cubit.dataAboutClubYouLead!.college!;
    _aboutClubController.text = cubit.dataAboutClubYouLead!.description ?? "";
    _membersNumController.text = cubit.dataAboutClubYouLead!.memberNum != null ? cubit.dataAboutClubYouLead!.memberNum.toString() : "";
    _phoneController.text = cubit.dataAboutClubYouLead!.contactAccounts != null ? cubit.dataAboutClubYouLead!.contactAccounts!.phone.toString() : '';
    _twitterController.text = cubit.dataAboutClubYouLead!.contactAccounts != null ? cubit.dataAboutClubYouLead!.contactAccounts!.twitter.toString() : '';
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text("تعديل بيانات النادي"),),
          body: BlocConsumer<ClubsCubit,ClubsStates>(
            listener: (context,state)
            {
              if( state is ClubUpdatedSuccessState )
              {
                showSnackBar(context: context, message: "تم تعديل البيانات بنجاح",backgroundColor: Colors.green,seconds: 2);
                _nameController.clear();
                _aboutClubController.clear();
                _twitterController.clear();
                _phoneController.clear();
                _nameController.clear();
                cubit.clubImage = null;
                Navigator.pushNamed(context, AppStrings.kLayoutScreen);
              }
              if( state is FailedToUpdateClubState )
              {
                showSnackBar(context: context, message: state.message,backgroundColor: Colors.red,seconds: 2);
              }
            },
            builder: (context,state){
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if( cubit.clubImage != null || cubit.dataAboutClubYouLead!.image != null )
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  _textUpperTextField(title: "هيكلة النادي"),
                                  Container(
                                    height: 125.h,
                                    width: 225.w,
                                    padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.black.withOpacity(0.4))
                                    ),
                                    child: GestureDetector(
                                        onTap: () => cubit.getClubImage(),
                                        child: cubit.clubImage != null ? Image.file(cubit.clubImage!,fit: BoxFit.cover,) : Image.network(cubit.dataAboutClubYouLead!.image!,fit: BoxFit.cover,)),
                                  )
                                ],
                              ),
                              if( cubit.clubImage == null && cubit.dataAboutClubYouLead!.image == null )
                              OutlinedButton(
                                onPressed : () => cubit.getClubImage(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      const Icon(Icons.image,color: Colors.green,),
                                      SizedBox(width: 10.w,),
                                      Text("اضغط لاختيار صورة",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.5.sp),)
                                    ],
                                  ),
                                ),
                              ),
                              _textUpperTextField(title: "اسم النادي"),
                              textFieldComponent(controller: _nameController),
                              _textUpperTextField(title: "الكلية"),
                              textFieldComponent(controller: _collegeController,enabled: false),
                              _textUpperTextField(title: "رقم التليفون"),
                              textFieldComponent(controller: _phoneController,textInputType: TextInputType.number),
                              _textUpperTextField(title: "حساب تويتر"),
                              textFieldComponent(controller: _twitterController),
                              _textUpperTextField(title: "عدد الأعضاء"),
                              textFieldComponent(controller: _membersNumController,textInputType: TextInputType.number),
                              _textUpperTextField(title: "عن النادي"),
                              textFieldComponent(controller: _aboutClubController,maxLines: 6),
                              SizedBox(height: 20.h,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      DefaultButton(
                        width: double.infinity,
                        onTap: ()
                        {
                          if( cubit.clubImage == null && cubit.dataAboutClubYouLead!.image != null )
                            {
                              showSnackBar(context: context, message: "برجاء اختيار صورة",backgroundColor: AppColors.kRedColor);
                            }
                          else if( cubit.clubImage != null && _nameController.text.isNotEmpty &&_aboutClubController.text.isNotEmpty &&_twitterController.text.isNotEmpty &&_membersNumController.text.isNotEmpty &&_phoneController.text.isNotEmpty)
                          {
                            cubit.updateClubData(clubID: clubID, image: cubit.clubImage!, name: _nameController.text, memberNum: int.parse(_membersNumController.text), aboutClub: _aboutClubController.text ,phone: _phoneController.text, twitter: _twitterController.text);
                          }
                          else
                          {
                            cubit.updateClubWithoutImage(clubID: clubID, imgUrl: cubit.dataAboutClubYouLead!.image!, name: _nameController.text, memberNum: int.parse(_membersNumController.text), aboutClub: _aboutClubController.text ,phone: _phoneController.text, twitter: _twitterController.text);
                          }
                        },
                        title: state is UpdateClubLoadingState ? "جاري التعديل" : "حفظ التعديلات",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _textUpperTextField({required String title}){
  return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),)
  );
}

