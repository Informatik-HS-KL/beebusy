import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'task.g.dart';

abstract class Task implements Built<Task, TaskBuilder> {
  factory Task([void Function(TaskBuilder) updates]) = _$Task;

  Task._();

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Task.serializer, this)
        as Map<String, dynamic>;
  }

  static Task fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Task.serializer, json);
  }

  static Serializer<Task> get serializer => _$taskSerializer;

  @nullable
  int get taskId;

  @nullable
  Project get project;

  @nullable
  String get title;

  @nullable
  String get description;

  @nullable
  DateTime get deadline;

  @nullable
  DateTime get created;

  @nullable
  Status get status;

  @nullable
  BuiltList<TaskAssignee> get assignees;
}
