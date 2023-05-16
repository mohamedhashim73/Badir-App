import 'package:bader_user_app/Core/Components/snackBar_item.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Utils/app_strings.dart';
import 'package:bader_user_app/Features/Clubs/Domain/Entities/club_entity.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../Core/Components/drawer_item.dart';
import '../../../../Core/Constants/enumeration.dart';
import '../../../../Core/Theme/app_colors.dart';
import '../../../Events/Domain/Entities/event_entity.dart';
import '../../../Clubs/Presentation/Controller/clubs_cubit.dart';
import '../../../Clubs/Presentation/Controller/clubs_states.dart';
import '../../../Events/Presentation/Controller/events_states.dart';
import '../../../Clubs/Presentation/Screens/club_details_screen.dart';
import '../../../Events/Presentation/Screens/event_details_screen.dart';
import '../../Domain/Entities/user_entity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = LayoutCubit.getInstance(context);
    if( layoutCubit.userData == null ) layoutCubit.getMyData();
    final clubsCubit = ClubsCubit.getInstance(context);
    if( clubsCubit.clubs.isEmpty ) clubsCubit.getClubsData();
    final eventsCubit = EventsCubit.getInstance(context);
    if( eventsCubit.allEvents.isEmpty ) eventsCubit.getAllEvents();
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: DrawerItem(),
            appBar: AppBar(
              backgroundColor: AppColors.kMainColor,
              elevation: 0,
              title: const Text("الرئيسية"),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 7.5.h),
            child: BlocConsumer<LayoutCubit,LayoutStates>(
              buildWhen: (pastState,currentState) => currentState is GetMyDataSuccessState ,
              listener: (context,state)
              {
                if( state is LogOutSuccessState ) Navigator.pushNamed(context, AppStrings.kLoginScreen);
                if( state is FailedToLogOut ) showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
              },
              builder: (context,state) {
                return layoutCubit.userData != null ? ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children:
                  [
                    _headingText(title: "احصائيات قد تهمك"),
                    SizedBox(height: 7.h,),
                    Row(
                      children:
                      [
                        Expanded(
                          child: BlocBuilder<ClubsCubit,ClubsStates>(
                            buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                            builder: (context,state) =>  _staticsDataItem(imagePath: "assets/images/clubs_num_icon.png", title: clubsCubit.clubs.length <= 10 ? "${clubsCubit.clubs.length} أندية" : "${clubsCubit.clubs.length} نادي"),
                          ),
                        ),
                        Expanded(child: _staticsDataItem(imagePath: "assets/images/clock_icon.png", title: "0 ساعة")),
                        Expanded(
                          child: Column(
                            children:
                            [
                              Image.asset("assets/images/members_num_icon.png",height: 70.h,width: 70.w,),
                              SizedBox(height: 2.5.h,),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance.collection(Constants.kMembersNumberCollectionName).doc('Number').snapshots(),
                                builder: (context,event)
                                {
                                  if( event.hasData )
                                  {
                                    int membersNum = event.data!.data() != null ? event.data!.data()!['total'] : 0;
                                    return FittedBox(fit:BoxFit.scaleDown,child: Text(membersNum > 10 ? "$membersNum عضو" : "$membersNum أعضاء",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                  }
                                  else
                                  {
                                    return FittedBox(fit:BoxFit.scaleDown,child: Text("لا يوجد أعضاء",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),));
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12.h,),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                        [
                          _headingText(title: "الأندية الطلابية"),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.pushNamed(context, AppStrings.kViewClubsScreen);
                            },
                            child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h,),
                    BlocBuilder<ClubsCubit,ClubsStates>(
                      buildWhen: (previousState,currentState) => currentState is GetClubsDataSuccessState && previousState != currentState,
                      builder: (context,state) {
                        return clubsCubit.clubs.isNotEmpty ?
                        SizedBox(
                          width: double.infinity,
                          height: 120.h,
                          child: ListView.separated(
                            separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: clubsCubit.clubs.length,
                            itemBuilder: (context,index)
                            {
                              return LayoutBuilder(
                                builder: (context,constraints)
                                {
                                  return _displayClubOverView(context:context,clubEntity: clubsCubit.clubs[index],maxWidth: constraints.maxWidth,maxHeight: constraints.maxHeight);
                                },
                              );
                            },
                          ),
                        ) : SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: Text("لا يتم اضافة أندية حتي الآن",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15.5.sp,fontWeight: FontWeight.w400),),
                        );
                      }
                    ),
                    SizedBox(height: 12.h,),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                        [
                          _headingText(title: "الفعاليات القادمة"),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.pushNamed(context, AppStrings.kPastAndNewEventsScreen);
                            },
                            child: Text("عرض الكل",style: TextStyle(color: AppColors.kYellowColor),),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h,),
                    BlocBuilder<EventsCubit,EventsStates>(
                        buildWhen: (previousState,currentState) => currentState is GetEventsDataSuccessState && previousState != currentState,
                        builder: (context,state) {
                          return eventsCubit.allEvents.isNotEmpty ?
                          SizedBox(
                            width: double.infinity,
                            height: 200.h,
                            child: ListView.separated(
                              separatorBuilder: (context,index) => SizedBox(width: 10.w,),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: eventsCubit.allEvents.length > 2 ? 2 : eventsCubit.allEvents.length,  // TODO: لان مش عاوز غير بالكتير هم عنصرين فقط
                              itemBuilder: (context,index)
                              {
                                return LayoutBuilder(
                                  builder: (context,constraints)
                                  {
                                    // TODO: eventDate => لان محتاج اعرف اذا كانت الفعاليه عدت ولا لا
                                    DateTime eventDate = Jiffy("${eventsCubit.allEvents[index].endDate!.trim()} ${eventsCubit.allEvents[index].time!.trim()}", "MMMM dd, yyyy h:mm a").dateTime;
                                    return _displayEventOverView(myData: layoutCubit.userData!,context:context,eventEntity: eventsCubit.allEvents[index],eventDateExpired: DateTime.now().isAfter(eventDate) ? true : false);
                                  },
                                );
                              },
                            ),
                          ) : SizedBox(
                            height: 50.h,
                            width: double.infinity,
                            child: Text("لا يتم اضافة فعاليات بعد",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15.5.sp,fontWeight: FontWeight.w400),),
                          );
                        }
                    ),
                  ],
                ) : const Center(child: CircularProgressIndicator(),);
              }
            ),
          )
        ),
      ),
    );
  }

  Widget _staticsDataItem({required String imagePath,required String title}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
      [
        Image.asset(imagePath,height: 70.h,width: 70.w,),
        SizedBox(height: 2.5.h,),
        FittedBox(fit:BoxFit.scaleDown,child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.5.sp),))
      ],
    );
  }

  Widget _headingText({required String title}) {
    return Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),);
  }

  Widget _displayClubOverView({required ClubEntity clubEntity,required double maxHeight,required double maxWidth,required BuildContext context}){
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClubDetailsScreen(club: clubEntity)));
      },
      child: Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
            color: AppColors.kMainColor,
            borderRadius: BorderRadius.circular(4.w)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:
          [
            Expanded(child: Text(clubEntity.name!,maxLines:1,style: TextStyle(overflow:TextOverflow.ellipsis,color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 16.sp),)),
            SizedBox(width: 7.5.w,),
            CircleAvatar(
              radius: 28.w,
              backgroundImage: clubEntity.image != null ? NetworkImage(clubEntity.image!) : null,
              backgroundColor: clubEntity.image != null ? null : Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget _displayEventOverView({required UserEntity myData,required BuildContext context,required EventEntity eventEntity,required bool eventDateExpired}){
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventDateExpired: false)));
      },
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.kMainColor,
          borderRadius: BorderRadius.circular(4.w)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text("# ${eventEntity.name}",maxLines:2,style: TextStyle(color: AppColors.kYellowColor,fontWeight: FontWeight.w500,fontSize: 15.sp),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Text(eventEntity.description!,style: TextStyle(color: AppColors.kWhiteColor,overflow:TextOverflow.ellipsis,fontWeight: FontWeight.w500,fontSize: 12.sp),maxLines: 2,),
              ),
            ),
            SizedBox(width: 4.w,),
            Align(
                alignment: AlignmentDirectional.topEnd,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  onPressed: ()
                  {
                    if ( myData.idForClubLead != null )
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(event: eventEntity,eventDateExpired: false)));
                      }
                    else if( ( myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(eventEntity.clubID) )|| eventEntity.forPublic == EventForPublicOrNot.public.name )
                      {
                        // TODO: Join to Event Function.....
                      }
                  },
                  textColor: ( myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(eventEntity.clubID) )|| eventEntity.forPublic == EventForPublicOrNot.public.name || myData.idForClubLead != null ? AppColors.kBlackColor : AppColors.kWhiteColor,
                  color: myData.idForEventsJoined != null && myData.idForEventsJoined!.contains(eventEntity.id) ? AppColors.kOrangeColor : ( myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(eventEntity.clubID) ) || eventEntity.forPublic == EventForPublicOrNot.public.name || myData.idForClubLead != null ? AppColors.kWhiteColor : AppColors.kRedColor,
                  child: Text(myData.idForClubLead != null ? "متابعة" : myData.idForEventsJoined != null && myData.idForEventsJoined!.contains(eventEntity.id) ? "تم الإلتحاق" : ( myData.idForClubsMemberIn != null && myData.idForClubsMemberIn!.contains(eventEntity.clubID) )|| eventEntity.forPublic == EventForPublicOrNot.public.name ? "انضم إلينا" : "خاصة",style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
              )
          ],
        ),
      ),
    );
  }

}
