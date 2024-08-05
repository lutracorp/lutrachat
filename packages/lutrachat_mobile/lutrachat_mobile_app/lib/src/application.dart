import 'package:flutter/material.dart';
import 'package:lutrachat_mobile_i18n/gen/i18n/strings.g.dart';

import 'screen/splash.dart';

/// Root widget of LutraChat mobile client application.
final class LutraChatMobileApplication extends StatelessWidget {
  const LutraChatMobileApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp(
        title: 'LutraChat',
        theme: ThemeData(brightness: Brightness.dark),
        routes: {
          '/': (_) => const SplashScreen(),
        },
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
