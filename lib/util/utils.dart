import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getFile(BuildContext context) {
  final wait = Completer<File?>();

  showModalBottomSheet(
    context: context,
    builder: (buildContext) {
      return Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: const Text('Camera'),
                trailing: Icon(
                  Icons.camera_alt_outlined,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final res = await _showPicker(ImageSource.camera);
                  wait.complete(res);
                },
              ),
              ListTile(
                title: const Text('Library'),
                trailing: Icon(
                  Icons.photo_camera_back,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final res = await _showPicker(ImageSource.gallery);
                  wait.complete(res);
                },
              ),
              ListTile(
                title: const Text('Cancel'),
                trailing: Icon(
                  Icons.cancel_outlined,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  wait.complete(null);
                },
              ),
            ],
          ),
        ],
      );
    },
  );

  return wait.future;
}

Future<File?> _showPicker(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
