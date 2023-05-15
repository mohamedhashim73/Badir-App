import 'package:bader_user_app/Core/Components/button_item.dart';
import 'package:bader_user_app/Core/Components/snackBar_item.dart';
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
  final infoAboutUserController = TextEditingController();
  ViewClubsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClubsCubit clubsCubit = ClubsCubit.getInstance(context);
    final UserEntity myData = LayoutCubit.getInstance(context).userData!;
    clubsCubit.filteredClubsData.clear();    // عشان لو كنت خرجت من الصفحه ورجعت تاني ميجبش داتا قديمه
    if( clubsCubit.clubs.isEmpty ) clubsCubit.getClubsData();
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
                automaticallyImplyLeading: false,
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
              body: clubsCubit.clubs.isNotEmpty ?
                  BlocConsumer<ClubsCubit,ClubsStates>(
                    buildWhen: (lastState,currentState)
                    {
                      return lastState != currentState && ( currentState is GetClubsDataSuccessState || currentState is GetFilteredClubsSuccessStatus);
                    },
                    listener: (context,state)
                    {
                      if( state is SendRequestForMembershipSuccessState )
                      {
                        clubsCubit.selectedCommittee = null;
                        infoAboutUserController.text = '';
                        Navigator.pop(context);
                        showSnackBar(context: context, message: "تم إرسال الطلب بنجاح في انتظار موافقة الأدمن",backgroundColor: AppColors.kGreenColor,seconds: 3);
                      }
                      if( state is FailedToSendRequestForMembershipState )
                      {
                        Navigator.pop(context);
                        showSnackBar(context: context, message: "حدث خطأ اثناء ارسال الطلب برجاء التأكد من الاتصال بالنت والمحاوله لاحقا",backgroundColor: Colors.red);
                      }
                    },
                    builder: (context,state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 12.w),
                        child: ListView.separated(
                          itemCount: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs.length : clubsCubit.filteredClubsData.length,
                          separatorBuilder: (context,index) => SizedBox(height: 25.h,),
                          itemBuilder: (context,index)
                          {
                            return _clubItem(myData:myData,club: clubsCubit.filteredClubsData.isEmpty ? clubsCubit.clubs[index] : clubsCubit.filteredClubsData[index],context: context,cubit: clubsCubit,requestMembershipController: infoAboutUserController);
                          },
                        ),
                      );
                    }
                  ):
                  Center(
                    child: CircularProgressIndicator(color:AppColors.kMainColor),
                  )
            );
          }
        ),
      ),
    );
  }
}

Widget _clubItem({required UserEntity myData,required ClubEntity club,required BuildContext context,required ClubsCubit cubit,required TextEditingController requestMembershipController}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children:
    [
      if( club.image != null )
        Container(
          height: 100.h,
          width: 200.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(club.image!),fit: BoxFit.cover),
            border: Border.all(color: Colors.black.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4)
          ),
        ),
      Text(club.name!,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
      SizedBox(height: 7.h,),
      Row(
        // TODO: If he is a leader only one item will be shown
        mainAxisAlignment: myData.idForClubLead != null ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        children:
        [
          DefaultButton(
              title: "متابعة",
              onTap: ()
              {
                // TODO: Open club details
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: club)));
              },
            horizontalPaddingValue: 15.w,
            roundedRectangleBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
            ),
            height: 35.h,
          ),
          if( myData.idForClubLead == null )    // TODO: AS it will be shown only if a Visitor or Member Not Leader....
          DefaultButton(
              title: myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(club.id.toString()) ? "تم الالتحاق" : "طلب عضوية",
              height: 35.h,
              horizontalPaddingValue: 15.w,
              backgroundColor: myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(club.id.toString()) ? Colors.orange : AppColors.kYellowColor,
              roundedRectangleBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
              ),
              onTap: ()
              {
                // TODO: ask for membership
                if( myData.idForClubsMemberIn == null || myData.idForClubsMemberIn!.contains(club.id.toString()) == false )
                  {
                    askMembershipDialog(context: context, cubit: cubit, controller: requestMembershipController, clubID: club.id.toString(), committeeName: cubit.selectedCommittee,requestUserName: LayoutCubit.getInstance(context).userData!.name!);
                  }
              }
          ),
        ],
      )
    ],
  );
}


