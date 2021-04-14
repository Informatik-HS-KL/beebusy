import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/user.dart';

class UserController extends ResourceController {
  UserController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllUsers() async {
    final Query<User> query = Query(context);

    final List<User> allUsers = await query.fetch();

    return Response.ok(allUsers);
  }

  @Operation.delete("userId")
  Future<Response> deleteUser(@Bind.path("userId") int userId) async {
    final Query<User> query = Query(context)
      ..where((x) => x.userId).equalTo(userId);

    await query.delete();

    return Response.noContent();
  }

  @Operation("PATCH", "userId")
  Future<Response> updateTask(
    @Bind.path("userId") int userId,
    @Bind.body(ignore: ["userId", "memberships"]) User user,
  ) async {
    final Query<User> query = Query(context)
      ..where((x) => x.userId).equalTo(userId);

    if (user.firstname != null) {
      query.values.firstname = user.firstname?.trim();
    }

    if (user.lastname != null) {
      query.values.lastname = user.lastname?.trim();
    }

    if (user.email != null) {
      query.values.email = user.email?.trim();
    }

    final User updatedUser = await query.updateOne();

    if (updatedUser == null) {
      return Response.notFound();
    }

    return Response.ok(updatedUser);
  }
}
