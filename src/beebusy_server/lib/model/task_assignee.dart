import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project_member.dart';
import 'package:beebusy_server/model/task.dart';

class TaskAssignee extends ManagedObject<_TaskAssignee>
    implements _TaskAssignee {}

@Table(name: "task_assignees", uniquePropertySet: [#projectMember, #task])
class _TaskAssignee {
  @primaryKey
  int id;

  @Relate(#assignedTasks, onDelete: DeleteRule.cascade, isRequired: true)
  ProjectMember projectMember;

  @Relate(#assignees, onDelete: DeleteRule.cascade, isRequired: true)
  Task task;
}
