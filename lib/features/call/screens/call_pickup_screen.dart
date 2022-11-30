import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
import 'package:whatsapp_ui/features/call/screens/call_screen.dart';
import 'package:whatsapp_ui/models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallPickupScreen({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final call = Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialed) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        call.callerPic,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  call: call,
                                  isGroupChat: false,
                                  channelId: call.callId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
