import 'package:beebusy_server/controller/projects/project_members_controller.dart';
import 'package:beebusy_server/controller/projects/project_tasks_controller.dart';
import 'package:beebusy_server/controller/projects/projects_controller.dart';
import 'package:beebusy_server/controller/tasks/task_assignees_controller.dart';
import 'package:beebusy_server/controller/tasks/tasks_controller.dart';
import 'package:beebusy_server/controller/users/login_controller.dart';
import 'package:beebusy_server/controller/users/register_controller.dart';
import 'package:beebusy_server/controller/users/user_controller.dart';
import 'package:beebusy_server/controller/users/user_projects_controller.dart';

import 'beebusy_server.dart';

class BeebusyServerChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = BeeBusyConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
    );

    context = ManagedContext(dataModel, persistentStore);

    CORSPolicy.defaultPolicy.allowedMethods.add("PATCH");
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/users/login").link(() => LoginController(context));
    router.route("/users/register").link(() => RegisterController(context));
    router.route("/users/[:userId]").link(() => UserController(context));
    router
        .route("/users/:userId/projects")
        .link(() => UserProjectsController(context));

    router
        .route('/projects/[:projectId]')
        .link(() => ProjectsController(context));
    router
        .route('/projects/:projectId/members/[:userId]')
        .link(() => ProjectMembersController(context));
    router
        .route("/projects/:projectId/tasks")
        .link(() => ProjectTasksController(context));

    router.route("/tasks/[:taskId]").link(() => TasksController(context));
    router
        .route("/tasks/:taskId/assignees/[:projectMemberId]")
        .link(() => TaskAssigneesController(context));

    return router;
  }
}

class BeeBusyConfig extends Configuration {
  BeeBusyConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
