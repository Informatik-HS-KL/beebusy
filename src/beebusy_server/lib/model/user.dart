import 'package:beebusy_server/beebusy_server.dart';
import 'package:beebusy_server/model/project_member.dart';

class User extends ManagedObject<_User> implements _User {
  @Serialize()
  String get nameInitials =>
      '${firstname.isNotEmpty ? firstname[0] : ""}${lastname.isNotEmpty ? lastname[0] : ""}';
}

@Table(name: "users")
class _User {
  @primaryKey
  int userId;

  @Column(unique: true)
  String email;

  String firstname;

  String lastname;

  ManagedSet<ProjectMember> memberships;
}
