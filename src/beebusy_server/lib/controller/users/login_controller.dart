import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/user.dart';

class LoginController extends ResourceController {
  LoginController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> login(@Bind.body(require: ["email"]) User user) async {
    final Query<User> query = Query(context)
      ..where((x) => x.email).equalTo(user.email);

    final User loggedInUser = await query.fetchOne();

    if (loggedInUser == null) {
      return Response.notFound();
    }

    return Response.ok(loggedInUser);
  }
}
