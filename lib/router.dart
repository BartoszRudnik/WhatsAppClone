import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/landing/screens/landing_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OtpScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: settings.arguments as String,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
  }
}
