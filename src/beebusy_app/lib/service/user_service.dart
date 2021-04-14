import 'dart:io';

import 'package:beebusy_app/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserService {
  UserService(this.httpClient);

  final Dio httpClient;

  Future<User> login(String email) async {
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/users/login',
      data: <String, dynamic>{'email': email},
    );

    final User loggedInUser = User.fromJson(response.data);

    return loggedInUser;
  }

  Future<User> register(User user) async {
    final Response<Map<String, dynamic>> response = await httpClient.post(
      '/users/register',
      data: user.toJson(),
    );

    final User registeredUser = User.fromJson(response.data);

    return registeredUser;
  }

  Future<List<User>> getAllUsers() async {
    final Response<List<dynamic>> response = await httpClient.get(
      '/users',
    );

    final List<User> allUsers = response.data
        .map((dynamic json) => User.fromJson(json as Map<String, dynamic>))
        .toList();

    return allUsers;
  }

  Future<bool> deleteUser(int userId) async {
    final Response<String> response = await httpClient.delete(
      '/users/$userId',
    );

    return response.statusCode == HttpStatus.noContent;
  }

  Future<User> updateUser({
    @required int userId,
    String firstname,
    String lastname,
    String email,
  }) async {
    final User user = User(
          (UserBuilder b) => b
        ..firstname = firstname
        ..lastname = lastname
        ..email = email,
    );

    final Response<Map<String, dynamic>> response = await httpClient.patch(
      '/users/$userId',
      data: user.toJson(),
    );

    final User updatedUser = User.fromJson(response.data);

    return updatedUser;
  }
}
