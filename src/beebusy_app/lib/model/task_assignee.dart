import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'task_assignee.g.dart';

abstract class TaskAssignee
    implements Built<TaskAssignee, TaskAssigneeBuilder> {
  factory TaskAssignee([void Function(TaskAssigneeBuilder) updates]) =
      _$TaskAssignee;

  TaskAssignee._();

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(TaskAssignee.serializer, this)
        as Map<String, dynamic>;
  }

  static TaskAssignee fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(TaskAssignee.serializer, json);
  }

  static Serializer<TaskAssignee> get serializer => _$taskAssigneeSerializer;

  @nullable
  int get id;

  @nullable
  ProjectMember get projectMember;

  @nullable
  Task get task;
}
