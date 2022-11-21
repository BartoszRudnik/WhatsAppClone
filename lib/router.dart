import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_ui/features/select_contacts/screen/select_contacts_screen.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

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
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileChatScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
  }
}
