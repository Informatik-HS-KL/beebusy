import 'package:beebusy_app/controller/add_teammember_controller.dart';
import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/settings_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/ui/widgets/add_projectmember_dialog.dart';
import 'package:beebusy_app/ui/widgets/alert_dialog.dart';
import 'package:beebusy_app/ui/widgets/buttons.dart';
import 'package:beebusy_app/ui/widgets/board_navigation.dart';
import 'package:beebusy_app/ui/widgets/scaffold/my_scaffold.dart';
import 'package:beebusy_app/ui/widgets/textfields.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:beebusy_app/ui/widgets/teammember_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends GetView<SettingsController> {
  static const String route = '/board/settings';

  final BoardController _boardController = Get.find();
  final ProjectService _projectService = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showActions: true,
      body: BoardNavigation(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => Container(
                  width: Get.width,
                  child: BodyTitle(
                    title: _boardController.selectedProject.value.name,
                    trailing:
                        ' - ${AppLocalizations.of(context).settingsLabel}',
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              Obx(
                () => Form(
                  key: controller.formKey,
                  child: Row(
                    children: <Widget>[
                      BrownText(
                        AppLocalizations.of(context).projectNameLabel,
                        isBold: true,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        width: 400,
                        child: controller.isEditingTitle.value
                            ? MyTextFormField(
                          maxLength: 50,
                                controller: controller.titleEditingController
                                  ..text = _boardController
                                      .selectedProject.value.name,
                                labelText: AppLocalizations.of(context)
                                    .projectNameLabel,
                                validator: (String value) {
                                  if (value.isBlank) {
                                    return AppLocalizations.of(context)
                                        .emptyError;
                                  }

                                  if (value.length > 50) {
                                    return AppLocalizations.of(context)
                                        .length50Error;
                                  }
                                  return null;
                                },
                              )
                            : BrownText(
                                _boardController.selectedProject.value.name),
                      ),
                      if (controller.isEditingTitle.value)
                        Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.check),
                              color: Theme.of(context).hintColor,
                              onPressed: () {
                                if (!controller.formKey.currentState.validate())
                                  return;

                                controller.isEditingTitle.value = false;
                                _projectService
                                    .updateName(
                                        projectId: _boardController
                                            .selectedProject.value.projectId,
                                        newName: controller
                                            .titleEditingController.value.text)
                                    .then((Project project) async {
                                  await _boardController.refreshUserProjects();
                                  _boardController
                                      .selectProject(project.projectId);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              color: Theme.of(context).hintColor,
                              onPressed: () {
                                controller.isEditingTitle.value = false;
                              },
                            ),
                          ],
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Theme.of(context).hintColor,
                          onPressed: () {
                            controller.isEditingTitle.value = true;
                          },
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BrownText(
                    '${AppLocalizations.of(context).teamMembersLabel}: ',
                    isBold: true,
                  ),
                  Expanded(
                    child: Obx(
                      () => Wrap(
                        spacing: 8,
                        children: <Widget>[
                          ...controller.projectMembers
                              .toList()
                              .map(
                                (User u) => TeamMemberContainer(
                                  name: '${u.firstname} ${u.lastname}',
                                  onPressed: () =>
                                      controller.removeProjectMember(u.userId),
                                  removable: _authController
                                          .loggedInUser.value.userId !=
                                      u.userId,
                                ),
                              )
                              .toList(),
                          Container(
                            width: 250,
                            constraints: const BoxConstraints(minHeight: 40),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => showDialog<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    GetBuilder<AddTeammemberController>(
                                  init: AddTeammemberController(),
                                  builder: (_) => AddTeamMemberDialog(),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              DangerZone(),
            ],
          ),
        ),
      ),
    );
  }
}

class DangerZone extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BrownText(
          AppLocalizations.of(context).dangerZoneLabel,
          isBold: true,
        ),
        Container(
          width: 1200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DangerZoneRow(
                title: AppLocalizations.of(context).archiveProjectTitle,
                subtitle: AppLocalizations.of(context).archiveProjectInfo,
                buttonText: AppLocalizations.of(context).archiveProjectButton,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => MyAlertDialog(
                    title: AppLocalizations.of(context).archiveProjectButton,
                    content:
                        AppLocalizations.of(context).archiveProjectQuestion,
                    onConfirm: controller.archiveProject,
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).hoverColor,
                thickness: 1,
              ),
              DangerZoneRow(
                title: AppLocalizations.of(context).deleteProjectTitle,
                subtitle: AppLocalizations.of(context).deleteProjectInfo,
                buttonText: AppLocalizations.of(context).deleteProjectButton,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => MyAlertDialog(
                    title: AppLocalizations.of(context).deleteProjectButton,
                    content: AppLocalizations.of(context).deleteProjectQuestion,
                    onConfirm: controller.deleteProject,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DangerZoneRow extends StatelessWidget {
  const DangerZoneRow({
    @required this.title,
    @required this.subtitle,
    @required this.buttonText,
    @required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BrownText(title, isBold: true),
            BrownText(subtitle),
          ],
        ),
        const Spacer(),
        MyRaisedButton(
          buttonText: buttonText,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
