import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTaskController extends GetxController {
  final TaskService _taskService = Get.find();
  final ProjectService _projectService = Get.find();
  final BoardController _boardController = Get.find();
  final TaskController _taskController = Get.find();

  final DateFormat _dateFormat = DateFormat.yMd();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxList<ProjectMember> assignees = <ProjectMember>[].obs;
  final RxList<ProjectMember> possibleAssignees = <ProjectMember>[].obs;
  final Rx<DateTime> deadline = DateTime.now().add(const Duration(days: 1)).obs;

  String get deadlineString => _dateFormat.format(deadline.value);

  @override
  void onReady() {
    super.onReady();
    _projectService
        .getAllProjectMembers(_boardController.selectedProject.value.projectId)
        .then((List<ProjectMember> projectMembers) =>
            possibleAssignees.addAll(projectMembers));
  }

  void addAssignee(int projectMemberId) {
    final ProjectMember assigneeToAdd = possibleAssignees
        .firstWhere((ProjectMember element) => element.id == projectMemberId);
    possibleAssignees
        .removeWhere((ProjectMember element) => element.id == projectMemberId);
    assignees.add(assigneeToAdd);
  }

  void removeAssignee(int projectMemberId) {
    final ProjectMember assigneeToRemove = assignees
        .firstWhere((ProjectMember element) => element.id == projectMemberId);
    assignees
        .removeWhere((ProjectMember element) => element.id == projectMemberId);
    possibleAssignees.add(assigneeToRemove);
  }

  void deadlineChanged(DateTime newDate) {
    if (newDate != null) {
      deadline.value = newDate;
    }
  }

  void createTask(BuildContext context) {
    final Task task = Task(
      (TaskBuilder b) => b
        ..title = titleController.text
        ..description = descriptionController.text
        ..deadline = deadline.value
        ..assignees = ListBuilder<TaskAssignee>(
          assignees
              .map(
                (ProjectMember projectMember) => TaskAssignee(
                  (TaskAssigneeBuilder b) => b.projectMember =
                      ProjectMemberBuilder()..id = projectMember.id,
                ),
              )
              .toList(),
        ),
    );

    _taskService
        .createTask(
          projectId: _boardController.selectedProject.value.projectId,
          task: task,
        )
        .then(
          (Task value) => _taskController
              .refreshTasks(_boardController.selectedProject.value),
        )
        .catchError(
      (Object error) {
        print(error);
        Get.snackbar<void>(
          AppLocalizations.of(context).defaultErrorText,
          AppLocalizations.of(context).saveTaskError,
          backgroundColor: Theme.of(context).colorScheme.error,
          colorText: Theme.of(context).colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
          maxWidth: 300,
          margin: const EdgeInsets.only(bottom: 8),
        );
      },
    );
    Get.back<void>();
  }
}
