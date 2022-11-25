import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  final String receiverUserId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  late TextEditingController messageController;
  bool isShowSendButton = false;

  void selectImage() async {
    File? file = await pickImageFromGallery(
      context,
    );

    if (file != null) {
      sendFileMessage(
        file,
        MessageEnum.image,
      );
    }
  }

  void selectVideo() async {
    File? file = await pickVideoFromGallery(
      context,
    );

    if (file != null) {
      sendFileMessage(
        file,
        MessageEnum.video,
      );
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMesage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(
            chatControllerProvider,
          )
          .sendTextMessage(
            context,
            messageController.text.trim(),
            widget.receiverUserId,
          );

      messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    messageController = TextEditingController();

    messageController.addListener(
      () {
        if (messageController.text.isNotEmpty) {
          setState(() {
            isShowSendButton = true;
          });
        } else {
          setState(() {
            isShowSendButton = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => selectImage(),
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () => selectVideo(),
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(
              0xFF128C7E,
            ),
            child: GestureDetector(
              onTap: () {
                sendTextMessage();
              },
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
