import 'package:flutter/material.dart';

class SpeechControlsWidget extends StatelessWidget {
  final Function onConvertToSpeech;
  final Function onPauseSpeech;
  final Function onResumeSpeech;
  final Function onCancelSpeech;

  const SpeechControlsWidget({
    required this.onConvertToSpeech,
    required this.onPauseSpeech,
    required this.onResumeSpeech,
    required this.onCancelSpeech,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => onConvertToSpeech(),
            icon: Icon(Icons.volume_up, color: Colors.white),
            label: Text('Speak'),
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
            onPressed: () => onPauseSpeech(),
            icon: Icon(Icons.pause, color: Colors.white),
            label: Text('Pause'),
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
            onPressed: () => onResumeSpeech(),
            icon: Icon(Icons.play_arrow, color: Colors.white),
            label: Text('Resume'),
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
            onPressed: () => onCancelSpeech(),
            icon: Icon(Icons.stop, color: Colors.white),
            label: Text('Stop'),
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
      ),
    );
  }
}
