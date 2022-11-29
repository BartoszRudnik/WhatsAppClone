import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/group/repositories/group_repository.dart';

final groupControllerProvider = Provider(
  (ref) => GroupController(
    groupRepository: ref.watch(
      groupRepositoryProvider,
    ),
  ),
);

class GroupController {
  final GroupRepository groupRepository;

  GroupController({
    required this.groupRepository,
  });

  void createGroup(
    BuildContext context,
    String name,
    File file,
    List<Contact> selectedContacts,
  ) {
    groupRepository.createGroup(
      context,
      name,
      file,
      selectedContacts,
    );
  }
}
