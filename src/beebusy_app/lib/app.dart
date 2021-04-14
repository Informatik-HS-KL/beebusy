import 'package:beebusy_app/app_pages.dart';
import 'package:beebusy_app/controller/auth_controller.dart';
import 'package:beebusy_app/ui/pages/board_page.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:beebusy_app/ui/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BeeBusyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    final GetStorage storage = GetStorage('theme');
    if (storage.hasData('isDarkMode')) {
      final bool isDarkMode = storage.read('isDarkMode');
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    return GetMaterialApp(
      themeMode: themeMode,
      initialBinding: BindingsBuilder<AuthController>.put(
        () => AuthController(),
        permanent: true,
      ),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'BeeBusy',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: GetStorage('auth').hasData('loggedInUser')
          ? BoardPage.route
          : LoginPage.route,
      getPages: pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
