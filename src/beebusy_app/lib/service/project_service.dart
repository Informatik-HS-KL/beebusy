import 'dart:io';

import 'package:beebusy_app/model/project.dart';
import 'package:beebusy_app/model/project_member.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProjectService {
  ProjectService(this.httpClient);

  final Dio httpClient;

  Future<List<Project>> getAllUserProjects(int userId) async {
    final Response<List<dynamic>> response = await httpClient.get(
      '/users/$userId/projects',
    );

    final List<Project> allUserProjects = response.data
        .map((dynamic json) => Project.fromJson(json as Map<String, dynamic>))
        .toList();

    return allUserProjects;
  }

  Future<Project> getSingleProject(int projectId) async {
    final Response<Map<String, dynamic>> response = await httpClient.get(
      '/projects/$projectId',
    );

    final Project project = Project.fromJson(response.data);

    return project;
  }

  Future<Project> createProject(Project project) async {
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/projects',
      data: project.toJson(),
    );

    final Project createdProject = Project.fromJson(response.data);

    return createdProject;
  }

  Future<bool> deleteProject(int projectId) async {
    final Response<String> response = await httpClient.delete(
      '/projects/$projectId',
    );

    return response.statusCode == HttpStatus.noContent;
  }

  Future<List<ProjectMember>> getAllProjectMembers(int projectId) async {
    final Response<List<dynamic>> response = await httpClient.get(
      '/projects/$projectId/members',
    );

    final List<ProjectMember> allMembers = response.data
        .map((dynamic json) =>
            ProjectMember.fromJson(json as Map<String, dynamic>))
        .toList();

    return allMembers;
  }

  Future<ProjectMember> addProjectMember({
    @required int projectId,
    @required int userId,
  }) async {
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/projects/$projectId/members/$userId',
    );

    final ProjectMember membership = ProjectMember.fromJson(response.data);

    return membership;
  }

  Future<bool> removeProjectMember({
    @required int projectId,
    @required int userId,
  }) async {
    final Response<String> response = await httpClient.delete(
      '/projects/$projectId/members/$userId',
    );

    return response.statusCode == HttpStatus.noContent;
  }

  Future<Project> archiveProject(int projectId) async {
    return _updateProject(projectId: projectId, isArchived: true);
  }

  Future<Project> unarchiveProject(int projectId) async {
    return _updateProject(projectId: projectId, isArchived: false);
  }

  Future<Project> updateName({
    @required int projectId,
    @required String newName,
  }) async {
    return _updateProject(projectId: projectId, newName: newName);
  }

  Future<Project> _updateProject({
    @required int projectId,
    String newName,
    bool isArchived,
  }) async {
    final Project project = Project(
      (ProjectBuilder b) => b
        ..isArchived = isArchived
        ..name = newName,
    );

    final Response<Map<String, dynamic>> response = await httpClient.patch(
      '/projects/$projectId',
      data: project.toJson(),
    );

    final Project updatedProject = Project.fromJson(response.data);

    return updatedProject;
  }
}
