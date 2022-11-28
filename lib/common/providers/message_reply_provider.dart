import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply({
    required this.isMe,
    required this.message,
    required this.messageEnum,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>(
  (ref) => null,
);
