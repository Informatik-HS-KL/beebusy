import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 125.0,
      child: Image.asset(
        Get.isDarkMode
            ? 'images/bee_busy_logo_dark_mode.png'
            : 'images/bee_busy_logo_light_mode.png',
      ),
    );
  }
}
