import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:imagetotext/SplashScreen.dart';
import 'ImageToTextConverter.dart';

void main() async{
  await Hive.initFlutter();
  runApp(ImageToTextApp());
}

class ImageToTextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image to Text Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black87),
          titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

