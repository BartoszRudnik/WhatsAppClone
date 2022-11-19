import 'package:flutter/material.dart';

class UserInformationScreen extends StatelessWidget {
  static const String routeName = "/user-information";

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: ,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
