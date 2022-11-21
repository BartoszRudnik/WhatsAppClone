import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';

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

  Future<UserModel?> getCurrentUserData() async {
    final userData = await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser?.uid).get();

    UserModel? userModel;

    if (userData.data() != null) {
      userModel = UserModel.fromMap(
        userData.data()!,
      );
    }

    return userModel;
  }

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

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef providerRef,
    required BuildContext context,
  }) async {
    try {
      final navigator = Navigator.of(context);
      final uid = firebaseAuth.currentUser!.uid;
      String photoUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await providerRef.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      final userModel = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber!,
        groupIdList: [],
      );

      await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            uid,
          )
          .set(
            userModel.toMap(),
          );

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
