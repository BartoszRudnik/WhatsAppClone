import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/group.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(
      chatRepositoryProvider,
    ),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<Message>> getGroupMessages(String groupId) {
    return chatRepository.getGroupMessages(groupId);
  }

  Stream<List<Message>> getMessages(String receiverId) {
    return chatRepository.getMessages(receiverId);
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) {
    late UserModel userModel;

    ref.read(userDataAuthProvider).when(
          data: (data) => userModel = data!,
          error: (error, stackTrace) {},
          loading: () {},
        );

    chatRepository.sendTextMessage(
      context: context,
      text: text,
      receiverUserId: receiverUserId,
      senderUser: userModel,
      messageReply: ref.read(
        messageReplyProvider,
      ),
      isGroupChat: isGroupChat,
    );

    ref.read(messageReplyProvider.notifier).update(
          (state) => null,
        );
  }

  void sendGifMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
    bool isGroupChat,
  ) {
    late UserModel userModel;

    ref.read(userDataAuthProvider).when(
          data: (data) => userModel = data!,
          error: (error, stackTrace) {},
          loading: () {},
        );

    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    final newGifUrl = 'https://i.giphy.com/media/${gifUrl.substring(gifUrlPartIndex)}/200.gif';

    chatRepository.sendGifMessage(
      context: context,
      gifUrl: newGifUrl,
      receiverUserId: receiverUserId,
      senderUser: userModel,
      messageReply: ref.read(
        messageReplyProvider,
      ),
    );

    ref.read(messageReplyProvider.notifier).update(
          (state) => null,
        );
  }

  void sendFileMesage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    late UserModel userModel;

    ref.read(userDataAuthProvider).when(
          data: (data) => userModel = data!,
          error: (error, stackTrace) {},
          loading: () {},
        );

    chatRepository.sendFileMessage(
      context: context,
      file: file,
      receiverUserId: receiverUserId,
      senderUserData: userModel,
      ref: ref,
      messageEnum: messageEnum,
      messageReply: ref.read(
        messageReplyProvider,
      ),
      isGroupChat: isGroupChat,
    );

    ref.read(messageReplyProvider.notifier).update(
          (state) => null,
        );
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
