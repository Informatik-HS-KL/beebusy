import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project.dart';
import 'package:beebusy_server/model/project_member.dart';

class ProjectMembersController extends ResourceController {
  ProjectMembersController(this.context);

  final ManagedContext context;

  @Operation.get("projectId")
  Future<Response> getAllProjectMembers(
    @Bind.path("projectId") int projectId,
  ) async {
    final Query<Project> query = Query(context)
      ..where((x) => x.projectId).equalTo(projectId)
      ..join(set: (x) => x.members).join(object: (x) => x.user);

    final Project project = await query.fetchOne();

    if (project == null) {
      return Response.notFound();
    }

    final List<ProjectMember> members = project.members;

    return Response.ok(members);
  }

  @Operation.post("projectId", "userId")
  Future<Response> addProjectMember(
    @Bind.path("projectId") int projectId,
    @Bind.path("userId") int userId,
  ) async {
    final Query<ProjectMember> query = Query(context)
      ..values.project.projectId = projectId
      ..values.user.userId = userId;

    final ProjectMember createdProjectMember = await query.insert();

    return Response.ok(createdProjectMember);
  }

  @Operation.delete("projectId", "userId")
  Future<Response> removeProjectMember(
    @Bind.path("projectId") int projectId,
    @Bind.path("userId") int userId,
  ) async {
    final Query<ProjectMember> query = Query<ProjectMember>(context)
      ..where((x) => x.project.projectId).equalTo(projectId)
      ..where((x) => x.user.userId).equalTo(userId);

    await query.delete();

    return Response.noContent();
  }
}
