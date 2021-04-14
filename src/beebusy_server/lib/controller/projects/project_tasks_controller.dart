import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project.dart';
import 'package:beebusy_server/model/task.dart';
import 'package:beebusy_server/model/task_assignee.dart';

class ProjectTasksController extends ResourceController {
  ProjectTasksController(this.context);

  final ManagedContext context;

  @Operation.get("projectId")
  Future<Response> getAllTasksForProject(
    @Bind.path("projectId") int projectId,
  ) async {
    final Query<Project> query = Query(context)
      ..where((x) => x.projectId).equalTo(projectId)
      ..join(set: (x) => x.tasks)
          .join(set: (x) => x.assignees)
          .join(object: (x) => x.projectMember)
          .join(object: (x) => x.user);

    final Project project = await query.fetchOne();

    if(project == null) {
      return Response.notFound();
    }

    final List<Task> tasks = project.tasks;

    return Response.ok(tasks);
  }

  @Operation.post("projectId")
  Future<Response> createTaskForProject(
    @Bind.path("projectId") int projectId,
    @Bind.body(ignore: ["taskId", "created", "project"]) Task task,
  ) async {
    return context.transaction(
      (context) async {
        task.title = task.title?.trim();
        task.description = task.description?.trim();

        final Query<Task> createTaskQuery = Query(context)
          ..values = task
          ..values.project.projectId = projectId;

        final int createdTaskId = (await createTaskQuery.insert()).taskId;

        if (task.assignees != null) {
          for (TaskAssignee assignee in task.assignees) {
            final Query<TaskAssignee> addAssigneeQuery = Query(context)
              ..values.projectMember.id = assignee.projectMember.id
              ..values.task.taskId = createdTaskId;

            await addAssigneeQuery.insert();
          }
        }

        final Query<Task> taskQuery = Query(context)
          ..where((x) => x.taskId).equalTo(createdTaskId)
          ..join(set: (x) => x.assignees)
              .join(object: (x) => x.projectMember)
              .join(object: (x) => x.user);

        final Task createdTask = await taskQuery.fetchOne();

        return Response.ok(createdTask);
      },
    );
  }
}
