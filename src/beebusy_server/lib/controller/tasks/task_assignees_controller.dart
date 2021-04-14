import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/task_assignee.dart';

class TaskAssigneesController extends ResourceController {
  TaskAssigneesController(this.context);

  final ManagedContext context;

  @Operation.post("taskId", "projectMemberId")
  Future<Response> addAssignee(
    @Bind.path("taskId") int taskId,
    @Bind.path("projectMemberId") int projectMemberId,
  ) async {
    final Query<TaskAssignee> query = Query(context)
      ..values.task.taskId = taskId
      ..values.projectMember.id = projectMemberId;

    final TaskAssignee createdTaskAssignee = await query.insert();

    return Response.ok(createdTaskAssignee);
  }

  @Operation.delete("taskId", "projectMemberId")
  Future<Response> removeAssignee(
    @Bind.path("taskId") int taskId,
    @Bind.path("projectMemberId") int projectMemberId,
  ) async {
    final Query<TaskAssignee> query = Query(context)
      ..where((x) => x.task.taskId).equalTo(taskId)
      ..where((x) => x.projectMember.id).equalTo(projectMemberId);

    await query.delete();

    return Response.noContent();
  }
}
