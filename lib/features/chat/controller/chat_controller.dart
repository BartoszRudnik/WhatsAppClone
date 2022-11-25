import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
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

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
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
    );
  }
}
