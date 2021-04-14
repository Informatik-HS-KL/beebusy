import 'package:beebusy_server/beebusy_server.dart';

Future main() async {
  final app = Application<BeebusyServerChannel>()
    ..options.configurationFilePath = "config.src.yaml"
    ..options.port = 8887;

  await app.start(numberOfInstances: 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}