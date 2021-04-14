import 'package:beebusy_app/app.dart';
import 'package:beebusy_app/config.dart';
import 'package:beebusy_app/service/project_service.dart';
import 'package:beebusy_app/service/task_service.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';

Future<void> main() async {
  await Future.wait<bool>(<Future<bool>>[
    GetStorage.init('auth'),
    GetStorage.init('theme'),
  ]);

  Intl.defaultLocale = await findSystemLocale();

  final BaseOptions options = BaseOptions(
    baseUrl: 'http://$baseUrl:$port',
  );

  final Dio httpClient = Dio(options);

  Get.put(UserService(httpClient), permanent: true);
  Get.put(ProjectService(httpClient), permanent: true);
  Get.put(TaskService(httpClient), permanent: true);

  runApp(BeeBusyApp());
}
