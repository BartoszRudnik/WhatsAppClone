import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = "/select-contacts-screen";

  const SelectContactsScreen({
    Key? key,
  }) : super(key: key);

  void selectContact(WidgetRef ref, Contact contact, BuildContext context) {
    ref
        .read(
          selectContactControllerProvider,
        )
        .selectContact(
          contact,
          context,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Select contact',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  selectContact(
                    ref,
                    contactList[index],
                    context,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6),
                  child: ListTile(
                    leading: contactList[index].photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contactList[index].photo!),
                            radius: 30,
                          ),
                    title: Text(
                      contactList[index].displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: contactList.length,
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
