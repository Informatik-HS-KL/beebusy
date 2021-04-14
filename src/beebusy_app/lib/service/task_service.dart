import 'dart:io';

import 'package:beebusy_app/model/status.dart';
import 'package:beebusy_app/model/task.dart';
import 'package:beebusy_app/model/task_assignee.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TaskService {
  TaskService(this.httpClient);

  final Dio httpClient;

  Future<List<Task>> getAllProjectTasks(int projectId) async {
    final Response<List<dynamic>> response = await httpClient.get(
      '/projects/$projectId/tasks',
    );

    final List<Task> allProjectTasks = response.data
        .map((dynamic json) =>
            Task.fromJson(json as Map<String, dynamic>).rebuild(
              (TaskBuilder b) => b
                ..deadline = b.deadline?.toLocal()
                ..created = b.created?.toLocal(),
            ))
        .toList();

    allProjectTasks.sort((Task a, Task b) => a.taskId.compareTo(b.taskId));
    return allProjectTasks;
  }

  Future<Task> createTask({
    @required int projectId,
    @required Task task,
  }) async {
    task = task.rebuild(
      (TaskBuilder b) => b
        ..deadline = b.deadline?.toUtc()
        ..created = b.created?.toUtc(),
    );
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/projects/$projectId/tasks',
      data: task.toJson(),
    );

    final Task createdTask = Task.fromJson(response.data);

    return createdTask.rebuild(
      (TaskBuilder b) => b
        ..deadline = b.deadline?.toLocal()
        ..created = b.created?.toLocal(),
    );
  }

  Future<Task> updateTask({
    @required int taskId,
    String title,
    String description,
    DateTime deadline,
    Status status,
  }) async {
    final Task task = Task(
      (TaskBuilder b) => b
        ..title = title
        ..description = description
        ..deadline = deadline?.toUtc()
        ..status = status,
    );

    final Response<Map<String, dynamic>> response = await httpClient.patch(
      '/tasks/$taskId',
      data: task.toJson(),
    );

    final Task updatedTask = Task.fromJson(response.data);

    return updatedTask.rebuild(
      (TaskBuilder b) => b
        ..deadline = b.deadline?.toLocal()
        ..created = b.created?.toLocal(),
    );
  }

  Future<bool> deleteTask(int taskId) async {
    final Response<String> response = await httpClient.delete(
      '/tasks/$taskId',
    );

    return response.statusCode == HttpStatus.noContent;
  }

  Future<TaskAssignee> addAssignee({
    @required int taskId,
    @required int projectMemberId,
  }) async {
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/tasks/$taskId/assignees/$projectMemberId',
    );

    final TaskAssignee assignee = TaskAssignee.fromJson(response.data);

    return assignee;
  }

  Future<bool> removeAssignee({
    @required int taskId,
    @required int projectMemberId,
  }) async {
    final Response<String> response = await httpClient.delete(
      '/tasks/$taskId/assignees/$projectMemberId',
    );

    return response.statusCode == HttpStatus.noContent;
  }
}
