import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Components/alert_dialog_for_ask_membership.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Controller/clubs_cubit.dart';
import 'package:bader_user_app/Features/Layout/Domain/Entities/user_entity.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Clubs/Presentation/Screens/club_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controller/clubs_states.dart';

class ViewClubsScreen extends StatelessWidget {

  ViewClubsScreen({Key? key}) : super(key: key);

  final infoAboutUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context)..changeSearchAboutClubStatus(value: false);
    clubsCubit.filteredClubsData.clear();     // TODO: عشان لو كنت بحثت عن حاجه في HomePage
    // TODO: userID check it's value to know if he visitor or not
    UserEntity? myData = Constants.userID != null ? LayoutCubit.getInstance(context).userData! : null ;
    if( Constants.userID != null && clubsCubit.idForClubsIAskedToJoinAndWaitingResponse.isEmpty ) clubsCubit.getAllClubs(userEntity: myData);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<ClubsCubit,ClubsStates>(
          buildWhen: (lastState,currentState)
          {
            return currentState is ChangeSearchAboutClubStatus ;
          },
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: ()
                  {
                    clubsCubit.changeSearchAboutClubStatus(value: false);
                    clubsCubit.filteredClubsData.clear();
                    Navigator.pop(context);
                  },
                ),
                title: clubsCubit.searchEnabled ? TextField(
                  style: TextStyle(color: AppColors.kWhiteColor),
                  onChanged: (input)
                  {
                    clubsCubit.searchAboutClub(input: input);
                  },
                  decoration: InputDecoration(
                    hintText: 'ادخل اسم النادي',
                    hintStyle: TextStyle(color: AppColors.kWhiteColor),
                    border: InputBorder.none
                  ),
                ) : const Text("الأندية"),
                actions:
                [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: GestureDetector(
                      onTap: ()
                      {
                        clubsCubit.changeSearchAboutClubStatus();
                      },
                      child: clubsCubit.searchEnabled ? const Icon(Icons.clear) : const Icon(Icons.search),
                    ),
                  )
                ],
              ),
              body: BlocConsumer<ClubsCubit,ClubsStates>(
                    buildWhen: (pastState,currentState) => currentState is GetClubsDataSuccessState || currentState is GetFilteredClubsSuccessState,
                    listener: (context,state)
                    {
                      if( state is SendRequestForMembershipSuccessState )
                      {
                        clubsCubit.selectedCommittee = null;
                        infoAboutUserController.clear();
                        Navigator.pop(context);
                        showToastMessage(context: context, message: "تم إرسال الطلب بنجاح",backgroundColor: AppColors.kGreenColor,seconds: 3);
                      }
                      if( state is FailedToSendRequestForMembershipState )
                      {
                        Navigator.pop(context);
                        showToastMessage(context: context, message: "حدث خطأ اثناء ارسال الطلب",backgroundColor: Colors.red);
                      }
                    },
                    builder: (context,state) {
                      if( state is GetClubsDataSuccessState || state is GetFilteredClubsSuccessState || clubsCubit.clubs.isNotEmpty )
                        {
                          return ListView.builder(
                            itemCount: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs.length : clubsCubit.filteredClubsData.length,
                            itemBuilder: (context,index)
                            {
                              return _clubItem(myData: myData,club: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs[index] : clubsCubit.filteredClubsData[index],context: context,cubit: clubsCubit,requestMembershipController: infoAboutUserController);
                            },
                          );
                        }
                      else
                        {
                          return Center(
                            child: CircularProgressIndicator(color:AppColors.kMainColor),
                          );
                        }
                    }
                  )
            );
          }
        ),
      ),
    );
  }
}

Widget _clubItem({UserEntity? myData,required ClubEntity club,required BuildContext context,required ClubsCubit cubit,required TextEditingController requestMembershipController}){
  // TODO: بالنسبه لتلت متغيرات دول انا عامل if علي id بتاع المستخدم عشان اعرف اذا كان visitor ولا لا
  bool alreadyJoinedToClub = Constants.userID != null ? myData!.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(club.id.toString()) : false;
  bool clubAvailableAndHaveNotJoinedYetAndHaveNotSendRequestBefore = Constants.userID != null ? club.isAvailable == true && (myData!.idForClubsMemberIn == null || (myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(club.id.toString()) == false ) ) && (cubit.idForClubsIAskedToJoinAndWaitingResponse.contains(club.id.toString()) == false ) : false ;
  bool clubNotAvailableAndHaveNotJoinedYet = Constants.userID != null ? club.isAvailable == false && (myData!.idForClubsMemberIn == null || (myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(club.id.toString()) == false ) ) : false ;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
    child: GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: club)));
      },
      child: Card(
        elevation: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              Container(
                height: 85.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: club.image == null ? AppColors.kGreyColor : Colors.transparent,
                    image: club.image != null ? DecorationImage(image: NetworkImage(club.image!),fit: BoxFit.cover) : null,
                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(2)
                ),
                child: club.image == null ? Center(child: Icon(Icons.image,color: AppColors.kGreenColor,size: 35,)) : null,
              ),
              SizedBox(width: 20.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Text(club.name!,style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),),
                    SizedBox(height: 10.h,),
                    Row(
                      // TODO: If he is a leader only one item will be shown
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        _buttonItem(
                          title: "عرض",
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: club)));
                          },
                        ),
                        if( myData != null && myData.idForClubLead != null && Constants.userID != null )
                        SizedBox(width: 10.w,),
                        if( myData != null && myData.idForClubLead == null && Constants.userID != null )    // TODO: AS it will be shown only if a Visitor or Member Not Leader....
                          _buttonItem(
                              title: alreadyJoinedToClub ? "تم الالتحاق" : clubAvailableAndHaveNotJoinedYetAndHaveNotSendRequestBefore ? "إنضم إلينا" : clubNotAvailableAndHaveNotJoinedYet ? "غير متاح" : "تم طلب العضوية",
                              color: alreadyJoinedToClub ? AppColors.kGreenColor : clubAvailableAndHaveNotJoinedYetAndHaveNotSendRequestBefore ? AppColors.kMainColor : clubNotAvailableAndHaveNotJoinedYet ? AppColors.kRedColor : AppColors.kYellowColor,
                              onTap: ()
                              {
                                // TODO: ask for membership ( لازم يكون الليدر فاتح الانضمام للنادي غير كده مش هقدر )
                                if( clubAvailableAndHaveNotJoinedYetAndHaveNotSendRequestBefore )
                                {
                                  askMembershipDialog(context: context, cubit: cubit, controller: requestMembershipController, club: club,userEntity: LayoutCubit.getInstance(context).userData!);
                                }
                                else if( alreadyJoinedToClub )
                                {
                                  showToastMessage(context: context, message: "لقد تم الإنضمام للنادي بالفعل !!");
                                }
                                else if( clubNotAvailableAndHaveNotJoinedYet )
                                {
                                  showToastMessage(context: context, message: "لقد تم إيقاف الإنضمام للنادي من قبل الليدر تبعه",backgroundColor: AppColors.kRedColor);
                                }
                                else
                                {
                                  showToastMessage(context: context, message: "تم طلب العضوية بالفعل وف انتظار موافقه الليدر");
                                }
                              }
                          )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    ),
  );
}

Widget _buttonItem({required String title,required Function() onTap,Color? color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
        color: color ?? AppColors.kMainColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 3.h),
      child: Text(title,style: TextStyle(color: AppColors.kWhiteColor),),
    ),
  );
}



