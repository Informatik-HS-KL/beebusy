import 'dart:convert';

import 'package:beebusy_app/model/user.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final GetStorage _authStorage = GetStorage('auth');

  final Rx<User> loggedInUser = User().obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (_authStorage.hasData('loggedInUser')) {
      final String jsonString = _authStorage.read('loggedInUser');
      final User user =
          User.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
      if (user.userId != null) {
        loggedInUser.value = user;
        isLoggedIn.value = true;
      }
    }

    ever(
      loggedInUser,
      (User user) {
        _authStorage.write('loggedInUser', jsonEncode(user.toJson()));
      },
      condition: () => isLoggedIn.value,
    );
  }

  void logout() {
    Get.offAllNamed<void>(LoginPage.route);
    isLoggedIn.value = false;
    loggedInUser.value = User();
    _authStorage.erase();
  }
}
