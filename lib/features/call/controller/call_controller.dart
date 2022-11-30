import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/call/repository/call_repository.dart';
import 'package:whatsapp_ui/models/call.dart';

final callControllerProvider = Provider(
  (ref) => CallController(
    callRepository: ref.watch(
      callRepositoryProvider,
    ),
    providerRef: ref,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef providerRef;
  final FirebaseAuth firebaseAuth;

  CallController({
    required this.firebaseAuth,
    required this.callRepository,
    required this.providerRef,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void endCall(
    BuildContext context,
    String calledId,
    String receiverId,
  ) {
    callRepository.endCall(
      calledId,
      receiverId,
      context,
    );
  }

  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverId,
    String receiverPic,
  ) {
    providerRef.read(userDataAuthProvider).whenData(
      (value) {
        final callId = const Uuid().v1();

        final senderCallData = Call(
          callId: callId,
          callerId: firebaseAuth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverPic,
          hasDialed: true,
        );

        final receiverCallData = Call(
          callId: callId,
          callerId: firebaseAuth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverPic,
          hasDialed: false,
        );

        callRepository.makeCall(
          context,
          senderCallData,
          receiverCallData,
        );
      },
    );
  }
}
