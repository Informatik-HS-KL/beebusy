import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/create_project_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/widgets/add_project_dialog.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';

const bool _showArchiveButton = false;

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({this.showActions = false});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              Get.isDarkMode
                  ? 'images/bee_busy_logo_dark_mode.png'
                  : 'images/bee_busy_logo_light_mode.png',
            ),
            const Spacer(
              flex: 1,
            ),
            if (showActions)
              GetX<BoardController>(
                builder: (BoardController controller) => ProjectDropDown(
                  selectedProjectId: controller.selectedProject.value.projectId,
                ),
              ),
            const Spacer(
              flex: 8,
            ),
            if (showActions)
              Row(
                children: <Widget>[
                  GetX<AuthController>(builder: (AuthController controller) {
                    final User user = controller.loggedInUser.value;
                    return SizedBox(
                      width: 300,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BrownText('${user.firstname} ${user.lastname}'),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  MyPopupMenuButton(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProjectDropDown extends StatelessWidget {
  ProjectDropDown({Key key, this.selectedProjectId}) : super(key: key);

  final int selectedProjectId;
  final BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: Get.currentRoute.contains(ProfilePage.route)
          ? null
          : selectedProjectId,
      child: Row(
        children: <Widget>[
          BrownText(AppLocalizations.of(context).projectsLabel),
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      onSelected: (int value) {
        switch (value) {
          case -1:
            showDialog<void>(
              context: context,
              builder: (BuildContext context) =>
                  GetBuilder<CreateProjectController>(
                init: CreateProjectController(),
                builder: (_) => AddProjectDialog(),
              ),
            );
            break;
          default:
            if (value >= 0) {
              boardController.selectProject(value);
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        ...boardController.activeUserProjects
            .map<PopupMenuEntry<int>>(
              (Project project) => PopupMenuItem<int>(
                value: project.projectId,
                child: BrownText(project.name),
              ),
            )
            .toList(),
        if (boardController.activeUserProjects.isNotEmpty)
          const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: -1,
          child: BrownText(AppLocalizations.of(context).newProjectLabel),
        ),
        // no archive view
        if (_showArchiveButton)
          PopupMenuItem<int>(
            value: -2,
            child: BrownText(AppLocalizations.of(context).archiveLabel),
          ),
      ],
    );
  }
}

class MyPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: GetX<AuthController>(
          builder: (AuthController controller) => Text(
            controller.loggedInUser.value?.nameInitials ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: BrownText(AppLocalizations.of(context).profileLabel),
        ),
        PopupMenuItem<int>(
          enabled: false,
          value: -1,
          child: Row(
            children: <Widget>[
              BrownText(
                AppLocalizations.of(context).enableDarkModeLabel,
              ),
              const Spacer(),
              ValueBuilder<bool>(
                initialValue: Get.isDarkMode,
                builder: (bool isDarkMode, void updater(bool _)) {
                  return Switch(
                    value: isDarkMode,
                    onChanged: (bool isDarkMode) {
                      updater(isDarkMode);
                      final GetStorage storage = GetStorage('theme');
                      storage.write('isDarkMode', isDarkMode);
                      Get.changeThemeMode(
                        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: BrownText(AppLocalizations.of(context).logoutLabel),
        ),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            Get.toNamed<void>(ProfilePage.route);
            break;
          case 1:
            Get.find<AuthController>().logout();
            break;
        }
      },
    );
  }
}
