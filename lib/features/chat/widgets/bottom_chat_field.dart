import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/message_reply_preview.dart';

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
  late FocusNode focusNode;

  bool isShowSendButton = false;
  bool showEmojiPicker = false;

  void selectGif() async {
    final chatProvider = ref.read(chatControllerProvider);

    final gif = await pickGIF(context);

    if (gif != null) {
      chatProvider.sendGifMessage(
        context,
        gif.url!,
        widget.receiverUserId,
      );
    }
  }

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
    focusNode = FocusNode();

    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            showEmojiPicker = false;
          });
        }
      },
    );

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
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox.shrink(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                              onPressed: () {
                                setState(() {
                                  showEmojiPicker = !showEmojiPicker;
                                });

                                if (showEmojiPicker) {
                                  focusNode.unfocus();
                                } else {
                                  focusNode.requestFocus();
                                }
                              },
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Flexible(
                            child: IconButton(
                              onPressed: () => selectGif(),
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
                  onTap: () => sendTextMessage(),
                  child: Icon(
                    isShowSendButton ? Icons.send : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showEmojiPicker)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                messageController.text += emoji.emoji;
              },
            ),
          ),
      ],
    );
  }
}
