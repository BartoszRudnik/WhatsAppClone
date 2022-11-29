import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/group.dart' as group_model;

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
    providerRef: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef providerRef;

  GroupRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.providerRef,
  });

  void createGroup(BuildContext context, String name, File file, List<Contact> selectedContacts) async {
    try {
      List<String> members = [];

      for (final contact in selectedContacts) {
        final userColleciton = await firebaseFirestore
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

        if (userColleciton.docs.isNotEmpty && userColleciton.docs[0].exists) {
          members.add(
            userColleciton.docs[0].data()['uid'],
          );
        }
      }

      members.add(
        firebaseAuth.currentUser!.uid,
      );

      final groupId = const Uuid().v1();

      final profileUrl = await providerRef
          .read(
            commonFirebaseStorageRepositoryProvider,
          )
          .storeFileToFirebase(
            'grou/$groupId',
            file,
          );

      final group = group_model.Group(
        senderId: firebaseAuth.currentUser!.uid,
        name: name,
        groupId: groupId,
        groupPic: profileUrl,
        lastMessage: '',
        members: members,
        timeSent: DateTime.now(),
      );

      await firebaseFirestore
          .collection(
            'groups',
          )
          .doc(
            groupId,
          )
          .set(
            group.toMap(),
          );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
