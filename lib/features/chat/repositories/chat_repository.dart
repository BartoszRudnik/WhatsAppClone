import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firebaseFirestore
        .collection(
          'users',
        )
        .doc(firebaseAuth.currentUser!.uid)
        .collection(
          'chats',
        )
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> contacts = [];

        for (final document in event.docs) {
          final chatContact = ChatContact.fromMap(
            document.data(),
          );

          final userData = await firebaseFirestore
              .collection(
                'users',
              )
              .doc(
                chatContact.contactId,
              )
              .get();

          final user = UserModel.fromMap(
            userData.data()!,
          );

          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: user.uid,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
            ),
          );
        }

        return contacts;
      },
    );
  }

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      final timeSent = DateTime.now();

      final messageId = const Uuid().v1();

      final userDataMap = await firebaseFirestore
          .collection(
            'users',
          )
          .doc(
            receiverUserId,
          )
          .get();

      final receiverUserData = UserModel.fromMap(
        userDataMap.data()!,
      );

      _saveDataToContactsCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
      );
      _saveMessageToMessageSubcollection(
        text: text,
        timeSent: timeSent,
        receiverUserId: receiverUserId,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text,
        messageId: messageId,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void _saveDataToContactsCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
  ) async {
    final receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    final senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await Future.wait(
      [
        firebaseFirestore
            .collection(
              'users',
            )
            .doc(
              receiverUserData.uid,
            )
            .collection(
              'chats',
            )
            .doc(
              senderUserData.uid,
            )
            .set(
              receiverChatContact.toMap(),
            ),
        firebaseFirestore
            .collection(
              'users',
            )
            .doc(
              senderUserData.uid,
            )
            .collection(
              'chats',
            )
            .doc(
              receiverUserData.uid,
            )
            .set(
              senderChatContact.toMap(),
            ),
      ],
    );
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    await Future.wait(
      [
        firebaseFirestore
            .collection(
              'users',
            )
            .doc(
              firebaseAuth.currentUser!.uid,
            )
            .collection(
              'chats',
            )
            .doc(
              receiverUserId,
            )
            .collection(
              'messages',
            )
            .doc(
              messageId,
            )
            .set(
              message.toMap(),
            ),
        firebaseFirestore
            .collection(
              'users',
            )
            .doc(
              receiverUserId,
            )
            .collection(
              'chats',
            )
            .doc(
              firebaseAuth.currentUser!.uid,
            )
            .collection(
              'messages',
            )
            .doc(
              messageId,
            )
            .set(
              message.toMap(),
            ),
      ],
    );
  }
}
