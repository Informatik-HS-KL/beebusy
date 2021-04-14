import 'package:beebusy_app/model/project_member.dart';
import 'package:beebusy_app/model/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  factory User([void Function(UserBuilder) updates]) = _$User;

  User._();

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(User.serializer, this)
        as Map<String, dynamic>;
  }

  static User fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(User.serializer, json);
  }

  static Serializer<User> get serializer => _$userSerializer;

  @nullable
  int get userId;

  @nullable
  String get email;

  @nullable
  String get firstname;

  @nullable
  String get lastname;

  @nullable
  String get nameInitials;

  @nullable
  BuiltList<ProjectMember> get memberships;
}
