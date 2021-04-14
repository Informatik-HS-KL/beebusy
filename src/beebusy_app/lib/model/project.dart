import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/serializers.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

part 'project.g.dart';

abstract class Project implements Built<Project, ProjectBuilder> {
  factory Project([void Function(ProjectBuilder) updates]) = _$Project;

  Project._();

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Project.serializer, this)
        as Map<String, dynamic>;
  }

  static Project fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Project.serializer, json);
  }

  static Serializer<Project> get serializer => _$projectSerializer;

  @nullable
  int get projectId;

  @nullable
  String get name;

  @nullable
  bool get isArchived;

  @nullable
  BuiltList<ProjectMember> get members;

  @nullable
  BuiltList<Task> get tasks;
}
