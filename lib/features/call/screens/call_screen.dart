import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/config/agora_config.dart';
import 'package:whatsapp_ui/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({
    super.key,
    required this.call,
    required this.isGroupChat,
    required this.channelId,
  });

  final String channelId;
  final Call call;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late AgoraClient agoraClient;

  @override
  void initState() {
    super.initState();

    agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: '',
      ),
    );

    initAgora();
  }

  void initAgora() async {
    await agoraClient.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: agoraClient,
            ),
            AgoraVideoButtons(
              client: agoraClient,
            ),
          ],
        ),
      ),
    );
  }
}
