import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project.dart';
import 'package:beebusy_server/model/task_assignee.dart';
import 'package:beebusy_server/model/user.dart';

class ProjectMember extends ManagedObject<_ProjectMember>
    implements _ProjectMember {}

@Table(name: "project_members", uniquePropertySet: [#user, #project])
class _ProjectMember {
  @primaryKey
  int id;

  @Relate(#memberships, onDelete: DeleteRule.cascade, isRequired: true)
  User user;

  @Relate(#members, onDelete: DeleteRule.cascade, isRequired: true)
  Project project;

  ManagedSet<TaskAssignee> assignedTasks;
}
