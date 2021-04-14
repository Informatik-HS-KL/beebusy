import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'auth_controller.dart';

class SettingsController extends GetxController {
  final ProjectService _projectService = Get.find();

  final AuthController _authController = Get.find();
  final BoardController _boardController = Get.find();
  final TaskController _taskController = Get.find();

  final RxList<User> projectMembers = <User>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController titleEditingController = TextEditingController();

  RxBool isEditingTitle = false.obs;

  @override
  void onReady() {
    super.onReady();
    projectMembers.bindStream(
      _boardController.selectedProject.stream.asyncMap((Project project) {
        return _projectService
            .getAllProjectMembers(project.projectId)
            .then((List<ProjectMember> projectMembers) {
          return projectMembers.map((ProjectMember pm) => pm.user).toList();
        });
      }),
    );

    _projectService
        .getAllProjectMembers(_boardController.selectedProject.value.projectId)
        .then((List<ProjectMember> pms) {
      for (final ProjectMember pm in pms) {
        if (pm != null) {
          projectMembers.add(pm.user);
        }
      }
    });
  }

  void addProjectMember(User user) {
    if (user == null) {
      return;
    }

    if (user.userId == _authController.loggedInUser.value.userId) {
      return;
    }

    _projectService.addProjectMember(
        projectId: _boardController.selectedProject.value.projectId,
        userId: user.userId);

    projectMembers.add(user);
  }

  void removeProjectMember(int userId) {
    final User user = projectMembers.firstWhere((User u) => u.userId == userId);

    if (user == null) {
      return;
    }

    if (user.userId == _authController.loggedInUser.value.userId) {
      return;
    }

    _projectService.removeProjectMember(
        projectId: _boardController.selectedProject.value.projectId,
        userId: user.userId);

    projectMembers.remove(user);

    _taskController.refreshTasks(_boardController.selectedProject.value);
    _boardController.refreshTasks();
  }
}
