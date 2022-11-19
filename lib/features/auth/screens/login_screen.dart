import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/common/widgets/custom_button.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController phoneNumberController;
  Country? pickedCountry;

  @override
  void initState() {
    super.initState();

    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    phoneNumberController.dispose();
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();

    if (pickedCountry != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
            context: context,
            phoneNumber: pickedCountry!.phoneCode + phoneNumber,
          );
    } else {
      showSnackBar(
        context: context,
        content: 'Fill out all the fields',
      );
    }
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: const CountryListThemeData(
        backgroundColor: backgroundColor,
      ),
      onSelect: (value) {
        setState(() {
          pickedCountry = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Enter your phone number',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'WhatsApp will need to verify your phone number',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () => pickCountry(),
                    child: const Text(
                      'Pick country',
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(
                        pickedCountry == null ? '' : "+ ${pickedCountry!.phoneCode}",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            hintText: 'phone number',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: sendPhoneNumber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
