import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    super.key,
    required this.isGroupChat,
    required this.receiverId,
  });

  final String receiverId;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref
        .read(
          messageReplyProvider.notifier,
        )
        .update(
          (state) => MessageReply(
            isMe: isMe,
            message: message,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref.watch(chatControllerProvider).getGroupMessages(
                  widget.receiverId,
                )
            : ref
                .watch(
                  chatControllerProvider,
                )
                .getMessages(
                  widget.receiverId,
                ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Loader();

          SchedulerBinding.instance.addPostFrameCallback(
            (timeStamp) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            },
          );

          return ListView.builder(
            itemCount: snapshot.data!.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];

              if (!message.isSeen && message.receiverId == FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.receiverId,
                      message.messageId,
                    );
              }

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(
                    message.timeSent,
                  ),
                  messageEnum: message.type,
                  repliedText: message.repliedMessage,
                  username: message.repliedTo,
                  repliedMessageType: message.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                    message.text,
                    true,
                    message.type,
                  ),
                  isSeen: message.isSeen,
                );
              }
              return SenderMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(
                  message.timeSent,
                ),
                messageEnum: message.type,
                repliedText: message.repliedMessage,
                username: message.repliedTo,
                repliedMessageType: message.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  message.text,
                  false,
                  message.type,
                ),
              );
            },
          );
        });
  }
}
