import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    super.key,
    required this.receiverId,
  });

  final String receiverId;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref
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
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.easeInOutCubic,
              );
            },
          );

          return ListView.builder(
            itemCount: snapshot.data!.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(
                    message.timeSent,
                  ),
                );
              }
              return SenderMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(
                  message.timeSent,
                ),
              );
            },
          );
        });
  }
}
