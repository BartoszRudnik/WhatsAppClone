import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      final navigator = Navigator.of(context);

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );

      await firebaseAuth.signInWithCredential(
        credential,
      );

      navigator.pushNamedAndRemoveUntil(
        UserInformationScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void signingWithPhone(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async => await firebaseAuth.signInWithCredential(
          phoneAuthCredential,
        ),
        verificationFailed: (error) => throw Exception(
          error.message,
        ),
        codeSent: (verificationId, forceResendingToken) => Navigator.of(context).pushNamed(
          OtpScreen.routeName,
          arguments: verificationId,
        ),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
