import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find();
  final UserService _userService = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController firstNameEditingController =
      TextEditingController();
  final TextEditingController surNameEditingController =
      TextEditingController();
  final TextEditingController mailEditingController = TextEditingController();

  final RxBool isEditing = false.obs;

  User get currentUser => _authController.loggedInUser.value;

  void editPressed() {
    isEditing.value = true;
    firstNameEditingController.text = currentUser.firstname;
    surNameEditingController.text = currentUser.lastname;
    mailEditingController.text = currentUser.email;
  }

  void savePressed(BuildContext context) {
    if (formKey.currentState.validate()) {
      _userService
          .updateUser(
        userId: currentUser.userId,
        firstname: firstNameEditingController.text,
        lastname: surNameEditingController.text,
        email: mailEditingController.text,
      )
          .then(
        (User updatedUser) {
          _authController.loggedInUser.value = updatedUser;
          isEditing.value = false;
        },
      ).catchError(
        (Object error, Object _) {
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

  void deleteUserPressed() {
    _userService.deleteUser(currentUser.userId);
    _authController.logout();
  }
}
