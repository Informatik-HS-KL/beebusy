import 'dart:js' as js;

import 'package:flutter/foundation.dart' show kIsWeb;

final String baseUrl = kIsWeb && const bool.fromEnvironment('IS_PROD')
    ? js.JsObject.fromBrowserObject(js.context['env'])['baseUrl'] as String
    : const String.fromEnvironment(
        'BASE_URL',
        defaultValue: 'localhost',
      );

final String port = kIsWeb && const bool.fromEnvironment('IS_PROD')
    ? js.JsObject.fromBrowserObject(js.context['env'])['port'] as String
    : const String.fromEnvironment(
        'PORT',
        defaultValue: '8888',
      );
