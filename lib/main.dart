// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaralipi/screens/home/home_screen.dart';
import 'package:swaralipi/screens/onboarding/onboarding_screen.dart';
import 'package:swaralipi/screens/player/full_player_screen.dart';
import 'package:swaralipi/services/global_audio_service.dart';
import 'package:swaralipi/widgets/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global audio service
  final audioService = GlobalAudioService();
  audioService.init();

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(MyApp(onboardingComplete: onboardingComplete));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: onboardingComplete
          ? const AppWrapper(child: MyHomePage(title: 'Swaralipi'))
          : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      routes: {'/full_player': (context) => const FullPlayerScreen()},
      onGenerateRoute: (settings) {
        // Handle routes that need the AppWrapper
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) =>
                  const AppWrapper(child: MyHomePage(title: 'Swaralipi')),
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}
