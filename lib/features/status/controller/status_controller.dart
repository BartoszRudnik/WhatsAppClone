import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/status/repository/status_repository.dart';
import 'package:whatsapp_ui/models/status.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final statusControllerProvider = Provider(
  (ref) => StatusController(
    statusRepository: ref.read(
      statusRepositoryProvider,
    ),
    ref: ref,
  ),
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  Future<List<Status>> getStatuses({
    required BuildContext context,
  }) async {
    return await statusRepository.getStatus(
      context,
    );
  }

  void addStatus({
    required BuildContext context,
    required File statusImage,
  }) {
    late UserModel userData;

    ref.watch(userDataAuthProvider).when(
          data: (data) => userData = data!,
          error: (error, stackTrace) {},
          loading: () {},
        );

    statusRepository.uploadStatus(
      username: userData.name,
      profilePic: userData.profilePic,
      phoneNumber: userData.phoneNumber,
      statusImage: statusImage,
      context: context,
    );
  }
}
