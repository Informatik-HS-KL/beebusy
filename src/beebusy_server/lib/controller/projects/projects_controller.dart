import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project_member.dart';
import 'package:beebusy_server/model/project.dart';

class ProjectsController extends ResourceController {
  ProjectsController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllProjects() async {
    final Query<Project> query = Query(context)..join(set: (x) => x.members);

    final List<Project> projects = await query.fetch();

    return Response.ok(projects);
  }

  @Operation.get("projectId")
  Future<Response> getSingleProject(
    @Bind.path("projectId") int projectId,
  ) async {
    final Query<Project> query = Query(context)
      ..where((x) => x.projectId).equalTo(projectId)
      ..join(set: (x) => x.members);

    final Project project = await query.fetchOne();

    if (project == null) {
      return Response.notFound();
    }

    return Response.ok(project);
  }

  @Operation("PATCH", "projectId")
  Future<Response> updateProject(
    @Bind.path("projectId") int projectId,
    @Bind.body(ignore: ["projectId", "members", "tasks"]) Project project,
  ) async {
    final Query<Project> query = Query(context)
      ..where((x) => x.projectId).equalTo(projectId);

    if (project.name != null) {
      query.values.name = project.name?.trim();
    }

    if (project.isArchived != null) {
      query.values.isArchived = project.isArchived;
    }

    final Project updatedProject = await query.updateOne();

    if (updatedProject == null) {
      return Response.notFound();
    }

    return Response.ok(updatedProject);
  }

  @Operation.delete("projectId")
  Future<Response> deleteProject(
    @Bind.path("projectId") int projectId,
  ) async {
    final Query<Project> query = Query(context)
      ..where((x) => x.projectId).equalTo(projectId);

    await query.delete();

    return Response.noContent();
  }

  @Operation.post()
  Future<Response> createProject(
    @Bind.body(ignore: ["projectId", "isArchived"]) Project project,
  ) async {
    return context.transaction(
      (context) async {
        project.name = project.name?.trim();

        final Query<Project> createProjectQuery = Query(context)
          ..values = project;

        final int createdProjectId =
            (await createProjectQuery.insert()).projectId;

        if (project.members != null) {
          for (ProjectMember member in project.members) {
            final Query<ProjectMember> addMemberQuery = Query(context)
              ..values.user.userId = member.user.userId
              ..values.project.projectId = createdProjectId;

            await addMemberQuery.insert();
          }
        }

        final Query<Project> projectQuery = Query(context)
          ..where((x) => x.projectId).equalTo(createdProjectId)
          ..join(set: (x) => x.members);

        final Project createdProject = await projectQuery.fetchOne();

        return Response.ok(createdProject);
      },
    );
  }
}
