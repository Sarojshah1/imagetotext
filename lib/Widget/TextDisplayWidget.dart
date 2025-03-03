import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String text;

  const TextDisplayWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Text(
          text.isEmpty ? 'Recognized text will appear here.' : text,
          style: TextStyle(fontSize: 18, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
