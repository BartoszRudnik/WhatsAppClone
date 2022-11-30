import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
import 'package:whatsapp_ui/features/call/screens/call_pickup_screen.dart';
import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = "/mobile-chat-screen";

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isGroupChat,
  }) : super(key: key);

  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;

  void call(WidgetRef ref, BuildContext context) {
    ref
        .read(
          callControllerProvider,
        )
        .makeCall(
          context,
          name,
          uid,
          '',
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(
                  name,
                )
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(
                        uid,
                      ),
                  builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                      ? const Loader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                            ),
                            Text(
                              snapshot.data!.isOnline ? 'Online' : 'Offline',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => call(
                ref,
                context,
              ),
              icon: const Icon(
                Icons.video_call,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
