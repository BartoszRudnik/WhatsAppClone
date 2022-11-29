import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>(
  (ref) => [],
);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContacts = [];

  void selectContact(int index, Contact contact) {
    if (selectedContacts.contains(index)) {
      selectedContacts.remove(index);
      ref.read(selectedGroupContacts.notifier).update(
        (state) {
          state.remove(
            contact,
          );

          return state;
        },
      );
    } else {
      selectedContacts.add(index);
      ref.read(selectedGroupContacts.notifier).update(
        (state) {
          state.add(
            contact,
          );

          return state;
        },
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (data) => Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final contact = data[index];

                return InkWell(
                  onTap: () => selectContact(
                    index,
                    contact,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: selectedContacts.contains(index)
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Loader(),
        );
  }
}
