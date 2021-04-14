import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  Project,
  ProjectMember,
  Status,
  Task,
  TaskAssignee,
  User,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();
