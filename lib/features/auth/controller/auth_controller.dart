import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.watch(
      authRepositoryProvider,
    ),
    providerRef: ref,
  ),
);

final userDataAuthProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider);

    return authController.getUserData();
  },
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef providerRef;

  AuthController({
    required this.providerRef,
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

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      providerRef: providerRef,
      context: context,
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

  Future<UserModel?> getUserData() async {
    return authRepository.getCurrentUserData();
  }
}
