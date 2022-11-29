import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/group/controllers/group_controller.dart';
import 'package:whatsapp_ui/features/group/widgets/select_contacts.group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = "/create-group";

  const CreateGroupScreen({
    super.key,
  });

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? file;
  late TextEditingController controller;

  void selectImage() async {
    file = await pickImageFromGallery(context);
  }

  void createGroup() {
    if (controller.text.trim().isNotEmpty && file != null) {
      ref
          .read(
            groupControllerProvider,
          )
          .createGroup(
            context,
            controller.text.trim(),
            file!,
            ref.read(
              selectedGroupContacts,
            ),
          );

      ref
          .read(
            selectedGroupContacts.notifier,
          )
          .update(
            (state) => [],
          );

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create group',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                file == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                        ),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(
                          file!,
                        ),
                      ),
                Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.topLeft,
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
