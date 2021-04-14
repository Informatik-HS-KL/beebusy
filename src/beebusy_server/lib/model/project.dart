import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project_member.dart';
import 'package:beebusy_server/model/task.dart';

class Project extends ManagedObject<_Project> implements _Project {}

@Table(name: "projects")
class _Project {
  @primaryKey
  int projectId;

  String name;

  @Column(defaultValue: "FALSE")
  bool isArchived;

  ManagedSet<ProjectMember> members;

  ManagedSet<Task> tasks;
}
