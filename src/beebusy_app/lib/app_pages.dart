import 'package:beebusy_app/controller/board_controller.dart';
import 'package:beebusy_app/controller/login_controller.dart';
import 'package:beebusy_app/controller/profile_controller.dart';
import 'package:beebusy_app/controller/register_controller.dart';
import 'package:beebusy_app/controller/settings_controller.dart';
import 'package:beebusy_app/controller/task_controller.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:beebusy_app/ui/pages/profile_page.dart';
import 'package:beebusy_app/ui/pages/register_page.dart';
import 'package:beebusy_app/ui/pages/settings_page.dart';
import 'package:get/get.dart';

final List<GetPage> pages = <GetPage>[
  GetPage(
    name: RegisterPage.route,
    page: () => RegisterPage(),
    binding: BindingsBuilder<RegisterController>.put(
      () => RegisterController(),
    ),
  ),
  GetPage(
    name: LoginPage.route,
    page: () => LoginPage(),
    binding: BindingsBuilder<LoginController>.put(
      () => LoginController(),
    ),
  ),
  GetPage(
    name: BoardPage.route,
    page: () => BoardPage(),
    bindings: <Bindings>[
      BindingsBuilder<TaskController>.put(() => TaskController()),
      BindingsBuilder<BoardController>.put(() => BoardController()),
    ],
  ),
  GetPage(
    name: SettingsPage.route,
    page: () => SettingsPage(),
    bindings: <Bindings>[
      // TODO(dakr): remove for release
      BindingsBuilder<BoardController>.put(() => BoardController()),
      BindingsBuilder<SettingsController>.put(() => SettingsController()),
    ],
  ),
  GetPage(
    name: ProfilePage.route,
    page: () => ProfilePage(),
    binding: BindingsBuilder<ProfileController>.put(
          () => ProfileController(),
    ),
  ),
];
