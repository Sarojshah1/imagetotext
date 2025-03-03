import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function onPickImage;

  const ImagePickerWidget({required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onPickImage(),
      icon: Icon(Icons.camera_alt, size: 20),
      label: Text('Select Image or Take a Photo'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 8,
      ),
    );
  }
}
