import 'package:flutter/material.dart';

/// Screen showing loading animation.
final class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/otter.webp', width: 120, height: 120),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            const Text(
              'DID YOU KNOW',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
            ),
            const Text(
              'Otters so cute!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
