import 'package:bader_user_app/Core/Components/text_field_component.dart';
import 'package:bader_user_app/Core/Components/text_upper_textformfield.dart';
import 'package:bader_user_app/Core/Constants/constants.dart';
import 'package:bader_user_app/Core/Theme/app_colors.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_cubit.dart';
import 'package:bader_user_app/Features/Events/Presentation/Controller/events_states.dart';
import 'package:bader_user_app/Features/Layout/Presentation/Controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Components/alert_dialog_for_loading_item.dart';
import '../../../../Core/Components/button_item.dart';
import '../../../../Core/Components/drop_down_items.dart';
import '../../../../Core/Components/snackBar_item.dart';
import '../../Domain/Entities/task_entity.dart';

class UpdateTaskScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numOfPositionsController = TextEditingController();
  final TextEditingController _numOfHoursController = TextEditingController();
  final TaskEntity taskEntity;
  UpdateTaskScreen({Key? key,required this.taskEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idForClubILead = LayoutCubit.getInstance(context).userData!.idForClubLead!;
    EventsCubit eventsCubit = EventsCubit.getInstance(context)..getNamesOfEventsToUseInCreatingTask(idForClubILead: idForClubILead);
    _nameController.text = taskEntity.name;
    _descriptionController.text = taskEntity.name;
    _numOfPositionsController.text = taskEntity.numOfPosition.toString();
    _numOfHoursController.text = taskEntity.hours.toString();
    eventsCubit.eventNameForTaskCreated = taskEntity.eventName ?? "للعامة";
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("تعديل المهمة"),),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
              child: BlocConsumer<EventsCubit,EventsStates>(
                  listener: (context,state)
                  {
                    if( state is UpdateTaskLoadingState ) showLoadingDialog(context: context);
                    if( state is UpdateTaskSuccessState )
                    {
                      eventsCubit.taskOptionsForCreateIt.clear();
                      Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                      showSnackBar(context: context, message: "تم تعديل المهمة بنجاح");
                      Navigator.pop(context);
                    }
                    if( state is FailedToUpdateTaskState )
                    {
                      Navigator.pop(context);   // TODO : TO get out from Alert Dialog
                      showSnackBar(context: context, message: state.message,backgroundColor: AppColors.kRedColor);
                    }
                  },
                  builder: (context,state){
                    return ListView(
                      children:
                      [
                        dropDownComponent(
                            items: eventsCubit.taskOptionsForCreateIt,
                            onChanged: (val)
                            {
                              eventsCubit.chooseEventNameForTaskCreated(value: val!);
                            },
                            value: eventsCubit.eventNameForTaskCreated
                        ),
                        const TextUpperTextFormField(text: 'اسم المهمة'),
                        textFieldComponent(verticalPaddingValue:5.h,controller: _nameController),
                        const TextUpperTextFormField(text: 'وصف المهمة'),
                        textFieldComponent(verticalPaddingValue:5.h,controller: _descriptionController),
                        const TextUpperTextFormField(text: 'عدد الساعات'),
                        textFieldComponent(verticalPaddingValue:5.h,controller: _numOfHoursController,textInputType: TextInputType.number),
                        const TextUpperTextFormField(text: 'عدد الأشخاص'),
                        textFieldComponent(verticalPaddingValue:5.h,controller: _numOfPositionsController,textInputType: TextInputType.number),
                        SizedBox(height: 15.h,),
                        DefaultButton(
                            width: double.infinity,
                            onTap: ()
                            {
                              if( eventsCubit.eventNameForTaskCreated != null &&_nameController.text.isNotEmpty &&_descriptionController.text.isNotEmpty &&_numOfHoursController.text.isNotEmpty &&_numOfPositionsController.text.isNotEmpty )
                              {
                                bool taskForPublicOrSpecificEvent = eventsCubit.namesForEventsICreated.contains(eventsCubit.eventNameForTaskCreated) ? false : true ;
                                eventsCubit.updateTask(taskID: taskEntity.id, taskName: _nameController.text, clubID: taskEntity.clubID, hours: int.parse( _numOfHoursController.text.trim()), idForClubILead: idForClubILead, ownerID: Constants.userID ?? taskEntity.ownerID, numOfPosition: int.parse( _numOfPositionsController.text.trim()), numOfRegistered: taskEntity.numOfRegistered, description: _descriptionController.text, taskForPublicOrSpecificEvent: taskForPublicOrSpecificEvent);
                              }
                              else
                              {
                                showSnackBar(context: context, message: "برجاء إدخال البيانات كامله",backgroundColor: Colors.red,seconds: 2);
                              }
                            },
                            title: "تعديل"
                        ),
                      ],
                    );
                  },
              ),
            ),
          )
      ),
    );
  }

}
