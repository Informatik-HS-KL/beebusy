import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project.dart';
import 'package:beebusy_server/model/task_assignee.dart';

enum Status { todo, inProgress, review, done }

class Task extends ManagedObject<_Task> implements _Task {
  @override
  void willInsert() {
    created = DateTime.now().toUtc();
  }
}

@Table(name: "tasks")
class _Task {
  @primaryKey
  int taskId;

  @Relate(#tasks, onDelete: DeleteRule.cascade, isRequired: true)
  Project project;

  String title;

  String description;

  DateTime deadline;

  @Validate.absent(onInsert: false, onUpdate: true)
  DateTime created;

  @Column(defaultValue: "'todo'")
  Status status;

  //TODO validation: add only project members; not possible in aqueduct :(
  ManagedSet<TaskAssignee> assignees;
}
