import 'package:beebusy_app/model/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status.g.dart';

class Status extends EnumClass {
  const Status._(String name) : super(name);

  static BuiltSet<Status> get values => _$statusValues;

  static Status valueOf(String name) => _$statusValueOf(name);

  String serialize() {
    return serializers.serializeWith(Status.serializer, this) as String;
  }

  static Status deserialize(String string) {
    return serializers.deserializeWith(Status.serializer, string);
  }

  static Serializer<Status> get serializer => _$statusSerializer;

  static const Status todo = _$todo;
  static const Status inProgress = _$inProgress;
  static const Status review = _$review;
  static const Status done = _$done;
}
