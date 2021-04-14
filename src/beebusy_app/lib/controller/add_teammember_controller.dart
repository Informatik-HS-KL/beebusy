import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/settings_controller.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class AddTeammemberController extends GetxController {
  final ProjectService _projectService = Get.find();
  final UserService _userService = Get.find();

  final BoardController _boardController = Get.find();
  final SettingsController _settingsController = Get.find();

  final RxList<User> userList = <User>[].obs;
  final RxList<User> projectMembers = <User>[].obs;

  final TextEditingController titleEditingController = TextEditingController();

  RxBool isEditingTitle = false.obs;

  @override
  Future<void> onReady() async {
    super.onReady();

    final List<ProjectMember> pms = await _projectService.getAllProjectMembers(_boardController.selectedProject.value.projectId);

    _userService.getAllUsers().then((List<User> users) {
      users.removeWhere((User u) {
        for(final ProjectMember pm in pms) {
          if(pm.user == u)
            return true;
        }
        return false;
      });

      userList.addAll(users);
    });
  }

  // TODO(unknown): performance improvements - group-add instead of single add-requests
  void submit() {
    projectMembers.forEach(_settingsController.addProjectMember);
  }

  void addProjectMember(int userId) {
    final User user = userList.firstWhere((User u) => u.userId == userId);

    if (user == null) {
      return;
    }

    projectMembers.add(user);
    userList.refresh();
  }

  void removeProjectMember(int userId) {
    final User user = projectMembers.firstWhere((User u) => u.userId == userId);

    if (user == null) {
      return;
    }

    projectMembers.remove(user);
    userList.refresh();
  }

  bool isSelected(int userId) {
    for(final User u in projectMembers) {
      if(u.userId == userId)
        return true;
    }
    return false;
  }
}
