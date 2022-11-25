import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
    ),
  );
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyGet.getGif(
      context: context,
      apiKey: "32SmWJrHsisK95XUmncMcVoRRuCkrPog",
    );
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
  }

  return gif;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;

  try {
    final pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      video = File(
        pickedVideo.path,
      );
    } else {
      showSnackBar(
        context: context,
        content: 'Video has not been picked',
      );
    }
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
  }

  return video;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;

  try {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      image = File(
        pickedImage.path,
      );
    } else {
      showSnackBar(
        context: context,
        content: 'Image has not been picked',
      );
    }
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
  }
  return image;
}
