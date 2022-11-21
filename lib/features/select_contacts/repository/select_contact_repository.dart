import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({
    required this.firebaseFirestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }

    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      final userCollection = await firebaseFirestore.collection('users').get();

      bool isFound = false;

      for (final document in userCollection.docs) {
        final userData = UserModel.fromMap(
          document.data(),
        );

        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          navigator.pushNamed(
            MobileChatScreen.routeName,
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'User not found',
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
