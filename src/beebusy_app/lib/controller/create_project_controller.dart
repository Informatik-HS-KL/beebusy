import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateProjectController extends GetxController {
  final ProjectService _projectService = Get.find();
  final UserService _userService = Get.find();

  final AuthController _authController = Get.find();
  final BoardController _boardController = Get.find();

  final RxList<User> userList = <User>[].obs;
  final RxList<User> projectMembers = <User>[].obs;

  final TextEditingController projectTitleController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    _userService.getAllUsers().then((List<User> users) {
      userList.addAll(users);
    });
    userList.remove(_authController.loggedInUser.value);
    projectMembers.add(_authController.loggedInUser.value);
  }

  void addProjectMember(int userId) {
    final User user = userList.firstWhere((User u) => u.userId == userId);

    if(user == null) {
      return;
    }

    if(user.userId == _authController.loggedInUser.value.userId) {
      return;
    }

    projectMembers.add(user);
    userList.remove(user);
  }

  void removeProjectMember(int userId) {
    final User user = projectMembers.firstWhere((User u) => u.userId == userId);

    if(user == null) {
      return;
    }

    if(user.userId == _authController.loggedInUser.value.userId) {
      return;
    }

    userList.add(user);
    projectMembers.remove(user);
  }

  bool projectTitleChanged(String title) {
    if(title == null || title.isEmpty)
      return false;

    return true;
  }

  Future<void> createProject() async {
    final Project project = Project(
          (ProjectBuilder b) => b..name = projectTitleController.value.text,
    );

    Project createdProject;
    final List<ProjectMember> addedMembers = <ProjectMember>[];

    await _projectService.createProject(project).then((Project proj) {
      createdProject = proj;
    });

    // TODO(arlu): Report to user
    if (createdProject == null) {
      print('Error while creating project.');
      return;
    }

    for(final User u in projectMembers) {
      await _projectService.addProjectMember(
        projectId: createdProject.projectId,
        userId: u.userId,
      ).then((ProjectMember member) {
        if(member == null)
          return;

        addedMembers.add(member);
      });
    }

    // TODO(arlu): Report to user
    if (addedMembers.isEmpty) {
      print('Error while creating membership.');
      return;
    }

    await _boardController.refreshUserProjects();
    _boardController.selectProject(createdProject.projectId);
    Get.back<void>();
  }
}
