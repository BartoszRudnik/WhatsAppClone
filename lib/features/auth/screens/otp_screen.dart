import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  static const String routeName = "/otp-screen";

  const OtpScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final String verificationId;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late TextEditingController codeController;

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController();
  }

  @override
  void dispose() {
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Veryfing you phone number',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We have sent an SMS with a code',
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                onChanged: (value) {
                  if (value.trim().length == 6) {
                    ref.read(authControllerProvider).verifyOTP(
                          context: context,
                          userOTP: value.trim(),
                          verificationId: widget.verificationId,
                        );
                  }
                },
                textAlign: TextAlign.center,
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
