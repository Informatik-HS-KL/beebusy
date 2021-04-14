import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'project_member.g.dart';

abstract class ProjectMember
    implements Built<ProjectMember, ProjectMemberBuilder> {
  factory ProjectMember([void Function(ProjectMemberBuilder) updates]) =
      _$ProjectMember;

  ProjectMember._();

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(ProjectMember.serializer, this)
        as Map<String, dynamic>;
  }

  static ProjectMember fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(ProjectMember.serializer, json);
  }

  static Serializer<ProjectMember> get serializer => _$projectMemberSerializer;

  @nullable
  int get id;

  @nullable
  User get user;

  @nullable
  Project get project;
}
