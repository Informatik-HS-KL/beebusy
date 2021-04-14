import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/task.dart';

class TasksController extends ResourceController {
  TasksController(this.context);

  final ManagedContext context;

  @Operation("PATCH", "taskId")
  Future<Response> updateTask(
    @Bind.path("taskId") int taskId,
    @Bind.body(ignore: ["taskId", "created", "project", "assignees"]) Task task,
  ) async {
    final Query<Task> query = Query(context)
      ..where((x) => x.taskId).equalTo(taskId);

    if (task.title != null) {
      query.values.title = task.title?.trim();
    }

    if (task.description != null) {
      query.values.description = task.description?.trim();
    }

    if (task.deadline != null) {
      query.values.deadline = task.deadline;
    }

    if (task.status != null) {
      query.values.status = task.status;
    }

    final Task updatedTask = await query.updateOne();

    if (updatedTask == null) {
      return Response.notFound();
    }

    return Response.ok(updatedTask);
  }

  @Operation.delete("taskId")
  Future<Response> deleteTask(@Bind.path("taskId") int taskId) async {
    final Query<Task> query = Query(context)
      ..where((x) => x.taskId).equalTo(taskId);

    await query.delete();

    return Response.noContent();
  }
}
