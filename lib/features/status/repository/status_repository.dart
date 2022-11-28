import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/status.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    providerRef: ref,
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class StatusRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef providerRef;

  StatusRepository({
    required this.providerRef,
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      final statusId = const Uuid().v1();
      String uid = firebaseAuth.currentUser!.uid;

      final imageUrl = await providerRef
          .read(
            commonFirebaseStorageRepositoryProvider,
          )
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
      }

      List<String> uidWhoCanSee = [];

      for (final contact in contacts) {
        final userDataFirebase = await firebaseFirestore
            .collection(
              'users',
            )
            .where(
              'phoneNumber',
              isEqualTo: contact.phones[0].number.replaceAll(
                ' ',
                '',
              ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          final userData = UserModel.fromMap(
            userDataFirebase.docs[0].data(),
          );
          uidWhoCanSee.add(
            userData.uid,
          );
        }
      }

      List<String> statusImageUrls = [];

      final statusesSnapshot = await firebaseFirestore
          .collection(
            'status',
          )
          .where(
            'uid',
            isEqualTo: firebaseAuth.currentUser!.uid,
          )
          .where(
            'createdAt',
            isLessThan: DateTime.now().subtract(
              const Duration(
                hours: 24,
              ),
            ),
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        final status = Status.fromMap(
          statusesSnapshot.docs[0].data(),
        );

        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);

        firebaseFirestore
            .collection(
              'status',
            )
            .doc(
              statusesSnapshot.docs[0].id,
            )
            .update(
          {
            'photoUrl': statusImageUrls,
          },
        );

        return;
      } else {
        statusImageUrls = [
          imageUrl,
        ];

        Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: uidWhoCanSee,
        );

        await firebaseFirestore
            .collection(
              'status',
            )
            .doc(
              statusId,
            )
            .set(
              status.toMap(),
            );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];

    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );

        for (final contact in contacts) {
          final statusesSnapshot = await firebaseFirestore
              .collection(
                'status',
              )
              .where(
                'phoneNumber',
                isEqualTo: contact.phones[0].number.replaceAll(
                  ' ',
                  '',
                ),
              )
              .where(
                'createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(
                      const Duration(
                        hours: 24,
                      ),
                    )
                    .millisecondsSinceEpoch,
              )
              .get();

          for (final tempData in statusesSnapshot.docs) {
            final tempStatus = Status.fromMap(
              tempData.data(),
            );

            if (tempStatus.whoCanSee.contains(firebaseAuth.currentUser!.uid)) {
              statusData.add(
                tempStatus,
              );
            }
          }
        }
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }

    return statusData;
  }
}
