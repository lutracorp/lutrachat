import 'package:flutter/material.dart';

import 'screen/splash.dart';

/// Root widget of LutraChat mobile client application.
final class LutraChatMobileApplication extends StatelessWidget {
  const LutraChatMobileApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const SplashScreen(),
    );
  }
}
