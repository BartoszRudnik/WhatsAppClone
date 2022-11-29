import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/models/status.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';

  const StatusScreen({
    super.key,
    required this.status,
  });

  final Status status;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late StoryController storyController;
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();

    storyController = StoryController();

    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (final photoUrl in widget.status.photoUrl) {
      storyItems.add(
        StoryItem.pageImage(
          url: photoUrl,
          controller: storyController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                }
              },
            ),
    );
  }
}
