import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = "/otp-screen";

  const OtpScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
