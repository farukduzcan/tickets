import 'dart:io';

import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final String fileName;
  final String imagePath;

  const FileWidget({
    Key? key,
    required this.fileName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath.endsWith('.jpg') ||
        imagePath.endsWith('.jpeg') ||
        imagePath.endsWith('.png')) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Column(
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              height: 40,
            ),
            Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      );
    } else {
      IconData icon;
      Color? iconColor;

      if (imagePath.endsWith('.mp4') ||
          imagePath.endsWith('.mov') ||
          imagePath.endsWith('.avi')) {
        icon = Icons.video_library;
        iconColor = Colors.red;
      } else {
        icon = Icons.description;
        iconColor = Colors.grey;
      }

      return SizedBox(
        height: 60,
        width: 60,
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
            Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      );
    }
  }
}
