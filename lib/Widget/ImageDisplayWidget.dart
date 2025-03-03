import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplayWidget extends StatelessWidget {
  final File? image;

  const ImageDisplayWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.file(
              image!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                'No Image Selected',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          );
  }
}
