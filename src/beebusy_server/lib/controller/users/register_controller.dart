import 'package:aqueduct/aqueduct.dart';
import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> register(
    @Bind.body(ignore: ["userId", "projects"]) User user,
  ) async {
    user.email = user.email?.trim();
    user.firstname = user.firstname?.trim();
    user.lastname = user.lastname?.trim();
    
    final Query<User> query = Query(context)..values = user;

    final User createdUser = await query.insert();

    return Response.ok(createdUser);
  }
}
