import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("projects", [
      SchemaColumn("projectId", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("name", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("isArchived", ManagedPropertyType.boolean,
          isPrimaryKey: false,
          autoincrement: false,
          defaultValue: "FALSE",
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("project_members", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("tasks", [
      SchemaColumn("taskId", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("title", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("description", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("deadline", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("created", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("status", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          defaultValue: "'todo'",
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("task_assignees", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("users", [
      SchemaColumn("userId", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("email", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("firstname", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("lastname", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.addColumn(
        "project_members",
        SchemaColumn.relationship("user", ManagedPropertyType.bigInteger,
            relatedTableName: "users",
            relatedColumnName: "userId",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "project_members",
        SchemaColumn.relationship("project", ManagedPropertyType.bigInteger,
            relatedTableName: "projects",
            relatedColumnName: "projectId",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.alterTable("project_members", (t) {
      t.uniqueColumnSet = ["project", "user"];
    });
    database.addColumn(
        "tasks",
        SchemaColumn.relationship("project", ManagedPropertyType.bigInteger,
            relatedTableName: "projects",
            relatedColumnName: "projectId",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "task_assignees",
        SchemaColumn.relationship(
            "projectMember", ManagedPropertyType.bigInteger,
            relatedTableName: "project_members",
            relatedColumnName: "id",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "task_assignees",
        SchemaColumn.relationship("task", ManagedPropertyType.bigInteger,
            relatedTableName: "tasks",
            relatedColumnName: "taskId",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.alterTable("task_assignees", (t) {
      t.uniqueColumnSet = ["projectMember", "task"];
    });
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    await database.store.execute('''
    INSERT INTO users (email, firstname, lastname) VALUES
    ('max@test.de', 'Max', 'Mustermann'),
    ('anna@test.de', 'Anna', 'Bolika'),
    ('klaus@test.de', 'Klaus', 'Trophobie'),
    ('claire@test.de', 'Claire', 'Grube'),
    ('ariel@test.de', 'Ariel', 'L'),
    ('jan@test.de', 'Jan', 'F'),
    ('david@test.de', 'David', 'K');
    ''');

    await database.store.execute('''
    INSERT INTO projects (name, isArchived) VALUES
    ('BeeBusy', FALSE),
    ('Wedding', FALSE),
    ('Archived', TRUE);
    ''');

    await database.store.execute('''
    INSERT INTO project_members (user_userId, project_projectId) VALUES
    (2, 3),
    (5, 1),
    (6, 1),
    (7, 1),
    (7, 2),
    (3, 2);
    ''');

    await database.store.execute('''
    INSERT INTO tasks (project_projectId, title, description, status, created, deadline) VALUES
    (1, 'Create database', 'Create a new sql database table', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Create UI', '', 'inProgress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Write tests', 'write unit and integration tests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Write Dockerfile', 'Create Dockerfile for app', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Bake cake', 'Bake a cake for the wedding', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Invite guests', 'invite some guests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (3, 'Invite guests', 'invite some guests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    ''');

    await database.store.execute('''
    INSERT INTO task_assignees (projectMember_id, task_taskId) VALUES
    (4, 1),
    (3, 2),
    (2, 3),
    (3, 3),
    (4, 3),
    (5, 5),
    (6, 6);
    ''');
  }
}
