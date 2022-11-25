import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.dataSource,
  });

  final String dataSource;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = CachedVideoPlayerController.network(
      widget.dataSource,
    )..initialize().then(
        (value) => videoPlayerController.setVolume(
          1,
        ),
      );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(
            videoPlayerController,
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  videoPlayerController.pause();

                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  videoPlayerController.play();

                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              icon: isPlaying
                  ? const Icon(
                      Icons.pause_circle,
                    )
                  : const Icon(
                      Icons.play_circle,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
