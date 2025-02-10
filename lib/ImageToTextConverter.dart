import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class ImageToTextConverter extends StatefulWidget {
  @override
  _ImageToTextConverterState createState() => _ImageToTextConverterState();
}

class _ImageToTextConverterState extends State<ImageToTextConverter> {
  File? _image;
  String _recognizedText = '';
  bool _isProcessing = false;
  bool _isSpeaking = false; // Track if speech is playing
  String _selectedLanguage = 'English'; // Default language
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();
  final translator = GoogleTranslator(); // Translator package

  int _currentTextIndex = 0; // Track the current position in the text

  // Pick image from gallery or take a photo
  Future<void> _pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Text('Choose whether to pick an image from the gallery or take a new photo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera); // Camera
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery); // Gallery
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (source == null) return; // If no source was selected, return

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageSizeInMB = imageFile.lengthSync() / (1024 * 1024); // Convert to MB
      if (imageSizeInMB > 5) {
        _showErrorDialog('Image size is too large. Please select an image less than 5MB.');
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
        _recognizedText = ''; // Reset text for a new image
        _isProcessing = true;
      });
      await _performOCR();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performOCR() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text;
      });
      if (_recognizedText.isEmpty) {
        _showErrorDialog('No text found in the image. Please upload an image with text.');
      }
      
      if (_selectedLanguage == 'Nepali') {
        await _translateText();
      }
    } catch (e) {
      setState(() {
        _recognizedText = 'Error: Unable to process image.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
      textRecognizer.close();
    }
  }

  // Translate the recognized text to Nepali
  Future<void> _translateText() async {
    final translatedText = await translator.translate(_recognizedText, to: 'ne');
    setState(() {
      _recognizedText = translatedText.text;
    });
  }

  // Copy text to clipboard
  void _copyToClipboard() {
    FlutterClipboard.copy(_recognizedText).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Text copied to clipboard!'),
        backgroundColor: Colors.green,
      ));
    });
  }

  // Convert text to speech
  void _convertToSpeech() async {
    if (_recognizedText.isNotEmpty) {
      // Set the language based on the selected language
      if (_selectedLanguage == 'Nepali') {
        await _flutterTts.setLanguage('ne-IN'); // Nepali language code
      } else {
        await _flutterTts.setLanguage('en-US'); // English language code
      }

      await _flutterTts.speak(_recognizedText);
      setState(() {
        _isSpeaking = true;
      });
    }
  }

  // Pause speech
  void _pauseSpeech() async {
    if (_isSpeaking) {
      await _flutterTts.pause();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  // Resume speech
  void _resumeSpeech() async {
    if (!_isSpeaking) {
      await _flutterTts.speak(_recognizedText.substring(_currentTextIndex));
      setState(() {
        _isSpeaking = true;
      });
    }
  }

  // Cancel speech
  void _cancelSpeech() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  // Forward button functionality
  void _forwardText() {
    if (_currentTextIndex + 100 < _recognizedText.length) {
      setState(() {
        _currentTextIndex += 100;
      });
      _flutterTts.speak(_recognizedText.substring(_currentTextIndex));
    } else {
      setState(() {
        _currentTextIndex = _recognizedText.length;
      });
      _flutterTts.speak(_recognizedText.substring(_currentTextIndex));
    }
  }

  // Select language from dropdown
  void _selectLanguage(String? value) {
    setState(() {
      _selectedLanguage = value ?? 'English';
    });

    // If Nepali, translate the recognized text
    if (_selectedLanguage == 'Nepali' && _recognizedText.isNotEmpty) {
      _translateText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word to voice Converter'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        actions: [
          // Dropdown for language selection
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: _selectLanguage,
              items: ['English', 'Nepali'].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display picked image
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(
                  _image!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
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
              ),

            ElevatedButton.icon(
              onPressed: _pickImage,
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
            ),

            if (_isProcessing)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (_recognizedText.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _recognizedText,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    'Recognized text will appear here.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _convertToSpeech,
                    icon: Icon(Icons.volume_up,color: Colors.white,),
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
                    onPressed: _pauseSpeech,
                    icon: Icon(Icons.pause,color: Colors.white,),
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
                    onPressed: _resumeSpeech,
                    icon: Icon(Icons.play_arrow,color: Colors.white,),
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
                    onPressed: _cancelSpeech,
                    icon: Icon(Icons.stop,color: Colors.white,),
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
            ),



            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: Icon(Icons.copy,color: Colors.white,),
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
                  onPressed: _forwardText,
                  icon: Icon(Icons.forward,color: Colors.white,),
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
            ),
          ],
        ),
      ),
    );
  }
}
