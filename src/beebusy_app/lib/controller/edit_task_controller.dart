import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTaskController extends GetxController {
  EditTaskController({@required this.task});

  final Task task;

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
  void onInit() {
    super.onInit();
    titleController.text = task.title;
    descriptionController.text = task.description;
    assignees.addAll(
      task.assignees
          .map((TaskAssignee assignee) => assignee.projectMember)
          .toList(),
    );
    deadline.value = task.deadline;
  }

  @override
  void onReady() {
    super.onReady();
    _projectService
        .getAllProjectMembers(_boardController.selectedProject.value.projectId)
        .then((List<ProjectMember> projectMembers) {
      possibleAssignees.addAll(projectMembers);
      possibleAssignees.removeWhere(
        (ProjectMember possibleAssignee) => assignees.any(
            (ProjectMember assignee) => assignee.id == possibleAssignee.id),
      );
    });
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

  void updateTask(BuildContext context) {
    _updateAssignees();
    _taskService
        .updateTask(
          taskId: task.taskId,
          title: titleController.text,
          description: descriptionController.text,
          deadline: deadline.value,
        )
        .then(
          (Task value) => _taskController
              .refreshTasks(_boardController.selectedProject.value),
        )
        .catchError(
      (Object error) {
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

  void _updateAssignees() {
    final List<int> currentTaskAssigneesMemberIds =
        task.assignees.map((TaskAssignee ta) => ta.projectMember.id).toList();
    final List<int> desiredTaskAssigneesMemberIds =
        assignees.map((ProjectMember pm) => pm.id).toList();

    final List<int> taskAssigneesToRemove = currentTaskAssigneesMemberIds
        .skipWhile((int projectMemberId) =>
            desiredTaskAssigneesMemberIds.contains(projectMemberId))
        .toList();

    final List<int> taskAssigneesToAdd = desiredTaskAssigneesMemberIds
        .skipWhile((int projectMemberId) =>
            currentTaskAssigneesMemberIds.contains(projectMemberId))
        .toList();

    for (final int projectMemberId in taskAssigneesToAdd) {
      _taskService.addAssignee(
          taskId: task.taskId, projectMemberId: projectMemberId);
    }

    for (final int projectMemberId in taskAssigneesToRemove) {
      _taskService.removeAssignee(
          taskId: task.taskId, projectMemberId: projectMemberId);
    }
  }
}
