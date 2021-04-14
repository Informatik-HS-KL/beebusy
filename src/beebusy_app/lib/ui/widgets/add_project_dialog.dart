import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProjectDialog extends GetView<CreateProjectController> {
  final BoardController boardController = Get.find();
  final AuthController authController = Get.find();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 500,
        height: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: BodyTitle(
                  title: AppLocalizations.of(context).createProjectTitle,
                ),
              ),
              // TODO(jafe): Use form to handle validation
              Row(
                children: <Widget>[
                  Expanded(
                    child: MyTextFormField(
                      controller: controller.projectTitleController,
                      labelText: AppLocalizations.of(context).projectNameLabel,
                      maxLength: 50,
                      validator: (String value) {
                        if(value.isBlank) {
                          return AppLocalizations.of(context).emptyError;
                        }

                        if(value.length > 50) {
                          return AppLocalizations.of(context).length50Error;
                        }

                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: BrownText(
                          AppLocalizations.of(context).teamMembersLabel,
                        ),
                      ),
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 250,
                      child: Obx(
                        () => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MyDropDown<User>(
                              hintText: AppLocalizations.of(context)
                                  .addTeamMemberLabel,
                              possibleSelections: controller.userList,
                              onChanged: controller.addProjectMember,
                              valueBuilder: (User user) => user.userId,
                              textBuilder: (User user) =>
                                  '${user.firstname} ${user.lastname}',
                            ).build(context),
                            Expanded(
                              child: Scrollbar(
                                key: ValueKey<int>(controller.projectMembers.length),
                                controller: _scrollController,
                                isAlwaysShown: true,
                                child: ListView(
                                  controller: _scrollController,
                                  children: <Widget>[
                                    ...controller.projectMembers
                                        .toList()
                                        .map(
                                          (User u) => TeamMemberContainer(
                                            name:
                                                '${u.firstname} ${u.lastname}',
                                            onPressed: () => controller
                                                .removeProjectMember(u.userId),
                                            removable: authController
                                                    .loggedInUser
                                                    .value
                                                    .userId !=
                                                u.userId,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyFlatButton(
                    buttonText: AppLocalizations.of(context).cancelButton,
                    onPressed: () => Get.back<void>(),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  MyRaisedButton(
                      buttonText: AppLocalizations.of(context).saveLabel,
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            controller.projectMembers.isNotEmpty) {
                          controller.createProject();
                        }
                        // TODO(arlu): display error
                        print('TODO: Display Error \'empty memberlist\'');
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
