import 'package:beebusy_app/controller/edit_task_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/ui/widgets/edit_task_dialog.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'alert_dialog.dart';

class DraggableTaskCard extends StatelessWidget {
  const DraggableTaskCard({Key key, @required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Draggable<Task>(
          data: task,
          child: TaskCard(task: task, width: constraints.maxWidth),
          feedback: TaskCard(task: task, width: constraints.maxWidth),
          // not working, error from flutter when dragging
          // childWhenDragging: Opacity(
          //   opacity: 0.4,
          //   child: TaskCard(
          //       task: task,
          //       width: constraints.maxWidth),
          // ),
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({Key key, this.task, this.width}) : super(key: key);

  final Task task;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Card(
        child: InkWell(
          onTap: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => GetBuilder<EditTaskController>(
              init: EditTaskController(task: task),
              builder: (_) => EditTaskDialog(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BrownText(task.title),
                      Text(
                        '${AppLocalizations.of(context).deadlineLabel}: ${task.deadline == null ? AppLocalizations.of(context).noDeadlineText : DateFormat.yMd().format(task.deadline)}',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: task.assignees.map((TaskAssignee assignee) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: AssigneeAvatar(assignee: assignee),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).hintColor,
                    size: 16,
                  ),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => MyAlertDialog(
                      title: AppLocalizations.of(context).deleteTaskTitle,
                      content: AppLocalizations.of(context).deleteTaskQuestion,
                      onConfirm: () {
                        Get.find<TaskController>().deleteTask(task.taskId);
                        Get.back<void>();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssigneeAvatar extends StatelessWidget {
  const AssigneeAvatar({Key key, this.assignee}) : super(key: key);

  final TaskAssignee assignee;

  @override
  Widget build(BuildContext context) {
    final String fullName =
        '${assignee?.projectMember?.user?.firstname ?? ""} ${assignee?.projectMember?.user?.lastname ?? ""}';
    return Tooltip(
      message: fullName,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          assignee.projectMember.user.nameInitials,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
