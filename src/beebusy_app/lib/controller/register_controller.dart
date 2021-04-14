import 'package:async/async.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController extends GetxController {
  final UserService _userService = Get.find();

  bool isRegistering = false;
  CancelableOperation<void> registerOperation;

  void onRegister({
    @required String firstname,
    @required String lastname,
    @required String email,
    @required BuildContext context,
  }) {
    if (!isRegistering) {
      isRegistering = true;

      final User user = User(
        (UserBuilder b) => b
          ..email = email
          ..firstname = firstname
          ..lastname = lastname,
      );

      registerOperation = CancelableOperation<User>.fromFuture(
        _userService.register(user).whenComplete(() => isRegistering = false),
      ).then<void>(
        (User registeredUser) {
          Get.back<void>();
          Get.snackbar<void>(
            AppLocalizations.of(context).registerSuccessMessage,
            '',
            backgroundColor: Colors.green,
            colorText: Colors.black,
            snackPosition: SnackPosition.BOTTOM,
            messageText: Container(),
            maxWidth: 300,
            margin: const EdgeInsets.only(bottom: 8),
          );
        },
        onError: (Object error, _) {
          String errorText = AppLocalizations.of(context).defaultErrorText;
          if (error is DioError &&
              error.response.data['error'] == 'entity_already_exists') {
            errorText = AppLocalizations.of(context).emailTakenError;
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

  void onBack() {
    registerOperation?.cancel();
    Get.back<void>();
  }
}
