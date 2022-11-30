import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/call/screens/call_screen.dart';
import 'package:whatsapp_ui/models/call.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => firestore
      .collection(
        'call',
      )
      .doc(
        auth.currentUser!.uid,
      )
      .snapshots();

  void endCall(
    String calledId,
    String receiverId,
    BuildContext context,
  ) async {
    await firestore
        .collection(
          'call',
        )
        .doc(
          calledId,
        )
        .delete();

    await firestore
        .collection(
          'call',
        )
        .doc(
          receiverId,
        )
        .delete();
  }

  void makeCall(
    BuildContext context,
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      final navigator = Navigator.of(context);

      await firestore
          .collection(
            'call',
          )
          .doc(
            senderCallData.callerId,
          )
          .set(
            senderCallData.toMap(),
          );

      await firestore
          .collection(
            'call',
          )
          .doc(
            receiverCallData.callerId,
          )
          .set(
            receiverCallData.toMap(),
          );

      navigator.push(
        MaterialPageRoute(
          builder: (context) => CallScreen(
            call: senderCallData,
            isGroupChat: false,
            channelId: senderCallData.callId,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
