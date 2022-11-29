import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/status/controller/status_controller.dart';
import 'package:whatsapp_ui/features/status/screens/status_screen.dart';
import 'package:whatsapp_ui/models/status.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.watch(statusControllerProvider).getStatuses(
            context: context,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 2,
          ),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final status = snapshot.data![index];

              return Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: status,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          status.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            status.profilePic,
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    indent: 85,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
