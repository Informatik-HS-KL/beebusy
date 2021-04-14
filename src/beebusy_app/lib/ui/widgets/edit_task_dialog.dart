import 'package:beebusy_app/controller/edit_task_controller.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTaskDialog extends GetView<EditTaskController> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: BodyTitle(
                  title: AppLocalizations.of(context).editTaskTitle,
                ),
              ),
              Flexible(
                child: MyTextFormField(
                  controller: controller.titleController,
                  labelText: AppLocalizations.of(context).taskTitleLabel,
                  maxLines: 3,
                  minLines: 1,
                  maxLength: 50,
                  validator: (String value) {
                    if(value == null || value.isBlank) {
                      return AppLocalizations.of(context).emptyError;
                    }

                    if(value.length > 50) {
                      return AppLocalizations.of(context).length50Error;
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              MyTextFormField(
                controller: controller.descriptionController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
                labelText: AppLocalizations.of(context).descriptionLabel,
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: BrownText(
                          AppLocalizations.of(context).assigneeLabel,
                        ),
                      ),
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 250,
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (controller.possibleAssignees.isNotEmpty ||
                                controller.assignees.isEmpty)
                              MyDropDown<ProjectMember>(
                                hintText: AppLocalizations.of(context)
                                    .addAssigneeLabel,
                                possibleSelections:
                                    controller.possibleAssignees,
                                onChanged: controller.addAssignee,
                                valueBuilder: (ProjectMember projectMember) =>
                                    projectMember.id,
                                textBuilder: (ProjectMember projectMember) =>
                                    '${projectMember.user.firstname} ${projectMember.user.lastname}',
                              ),
                            Expanded(
                              child: Scrollbar(
                                key: ValueKey<int>(controller.assignees.length),
                                controller: _scrollController,
                                isAlwaysShown: true,
                                child: ListView(
                                  controller: _scrollController,
                                  children: <Widget>[
                                    ...controller.assignees
                                        .toList()
                                        .map(
                                          (ProjectMember element) =>
                                              TeamMemberContainer(
                                            name:
                                                '${element.user.firstname} ${element.user.lastname}',
                                            onPressed: () => controller
                                                .removeAssignee(element.id),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BrownText(AppLocalizations.of(context).deadlineLabel),
                  Obx(() => BrownText(controller.deadlineString)),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: controller.deadline.value,
                        firstDate:
                            DateTime.now().isBefore(controller.deadline.value)
                                ? DateTime.now()
                                : controller.deadline.value,
                        lastDate: controller.deadline.value
                            .add(const Duration(days: 3650)),
                        currentDate: controller.deadline.value,
                      ).then(controller.deadlineChanged);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyFlatButton(
                    buttonText: AppLocalizations.of(context).cancelButton,
                    onPressed: () => Get.back<void>(),
                  ),
                  const SizedBox(width: 30),
                  MyRaisedButton(
                    buttonText: AppLocalizations.of(context).saveLabel,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        controller.updateTask(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
