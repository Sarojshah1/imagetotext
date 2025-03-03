import 'package:flutter/material.dart';

class ActionButtonsWidget extends StatelessWidget {
  final Function onCopyToClipboard;
  final Function onForwardText;

  const ActionButtonsWidget({
    required this.onCopyToClipboard,
    required this.onForwardText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => onCopyToClipboard(),
          icon: Icon(Icons.copy, color: Colors.white),
          label: Text('Copy Text'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 8,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => onForwardText(),
          icon: Icon(Icons.forward, color: Colors.white),
          label: Text('Forward'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 8,
          ),
        ),
      ],
    );
  }
}
