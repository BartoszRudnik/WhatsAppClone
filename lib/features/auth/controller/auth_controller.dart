import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.watch(
      authRepositoryProvider,
    ),
  ),
);

class AuthController {
  final AuthRepository authRepository;

  AuthController({
    required this.authRepository,
  });

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.signingWithPhone(
      phoneNumber,
      context,
    );
  }

  void verifyOTP({
    required BuildContext context,
    required String userOTP,
    required String verificationId,
  }) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }
}
