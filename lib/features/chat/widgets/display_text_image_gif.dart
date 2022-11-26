import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final audioPlayer = AudioPlayer();

    switch (type) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.end,
        );
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
        );
      case MessageEnum.audio:
        return StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
              constraints: const BoxConstraints(
                minWidth: 100,
              ),
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.stop();
                } else {
                  await audioPlayer.play(
                    UrlSource(
                      message,
                    ),
                  );
                }

                setState(
                  () => isPlaying = !isPlaying,
                );
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
            );
          },
        );
      case MessageEnum.video:
        return VideoPlayer(
          dataSource: message,
        );
      case MessageEnum.gif:
        return CachedNetworkImage(
          imageUrl: message,
        );
    }
  }
}
