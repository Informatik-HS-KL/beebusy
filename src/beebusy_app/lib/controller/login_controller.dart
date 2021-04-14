import 'dart:html';

import 'package:async/async.dart';
import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/register_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  final UserService _userService = Get.find();
  final AuthController _authController = Get.find();

  bool isLoggingIn = false;
  CancelableOperation<void> loginOperation;

  void onLogin(String email, BuildContext context) {
    if (!isLoggingIn) {
      isLoggingIn = true;

      loginOperation = CancelableOperation<User>.fromFuture(
        _userService.login(email).whenComplete(() => isLoggingIn = false),
      ).then<void>(
        (User loggedInUser) {
          _authController.isLoggedIn.value = true;
          _authController.loggedInUser.value = loggedInUser;
          Get.offAndToNamed<void>(BoardPage.route);
        },
        onError: (Object error, StackTrace _) {
          String errorText = AppLocalizations.of(context).defaultErrorText;
          if (error is DioError &&
              error.response?.statusCode == HttpStatus.notFound) {
            errorText = AppLocalizations.of(context).userDoesNotExistError;
          }

          Get.snackbar<void>(
            errorText,
            '',
            backgroundColor: Theme.of(context).colorScheme.error,
            colorText: Theme.of(context).colorScheme.onError,
            snackPosition: SnackPosition.BOTTOM,
            messageText: Container(),
            maxWidth: 300,
            margin: const EdgeInsets.only(bottom: 8),
          );
        },
      );
    }
  }

  void onRegister() {
    loginOperation?.cancel();
    Get.toNamed<void>(RegisterPage.route);
  }
}
