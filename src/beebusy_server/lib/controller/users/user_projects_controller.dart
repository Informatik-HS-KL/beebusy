import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project.dart';
import 'package:beebusy_server/model/user.dart';

class UserProjectsController extends ResourceController {
  UserProjectsController(this.context);

  final ManagedContext context;

  @Operation.get("userId")
  Future<Response> getUserProjects(@Bind.path("userId") int userId) async {
    final Query<User> query = Query(context)
      ..where((x) => x.userId).equalTo(userId)
      ..join(set: (x) => x.memberships).join(object: (x) => x.project);

    final User user = await query.fetchOne();

    if (user == null) {
      return Response.notFound();
    }

    final List<Project> projects =
        user.memberships.map((membership) => membership.project).toList();

    return Response.ok(projects);
  }
}
