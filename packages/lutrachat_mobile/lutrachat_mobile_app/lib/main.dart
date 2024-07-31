import 'package:flutter/material.dart';
import 'package:lutrachat_mobile_i18n/gen/i18n/strings.g.dart';

import 'src/application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  runApp(
    const LutraChatMobileApplication(),
  );
}
